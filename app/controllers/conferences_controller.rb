#origin: GM

#require 'icalendar'

class ConferencesController < BaseController
  belongs_to :category, :optional => true
  belongs_to :series, :optional => true
  
  include Icalendar
  
  before_filter :authenticate_user!, :except => [:index]
  
  respond_to :html, :json
  before_filter :load_conference, :only => [:show, :update, :ical]
  
  verify :params => [:id], :only => [:show, :update]
  
  def show
    @my_contacts=current_user.contacts
    respond_to do |format|
      format.json { render :json => @conference }
      format.html { render } #TODO => change
    end
  end

  def search
    if params[:search_term]
      dummy_conf=Conference.new(params[:conference])
      if params[:search_term]=~/\:/
        opts=params[:search_term]
      else
        opts="" #build the search string
        opts<<" from:#{dummy_conf.start_date.to_s} " if dummy_conf.start_date
        opts<<" until:#{dummy_conf.end_date.to_s} " if dummy_conf.end_date
        opts<<" reg:#{params[:region]} " if !params[:region].blank? and params[:region]!="none"
        Category.find_all_by_id(params[:conference][:category_ids]).each do |cat|
          opts<<" cat:#{cat.name.gsub(" ","_")} " #a bit fragvile, but it works...
        end
        opts<<" #{params[:search_term]} "      
      end
      @conferences = ConferenceSearcher.do_find opts, current_user
    else
      @conferences = Conference.all.paginate
    end
    
    respond_to do |format|
      format.json { empty_safe(@conferences) { render :json => @conferences } }
      format.html { render }
    end
  end
  
  def create
    p = params[:conference] || request.POST
    
    Array(p[:categories]).map! do |c|
      Category.find_or_create_by_name(c[:name])
    end
    
    @conference = Conference.new(p)
    @conference.creator = current_user
    
    create! do |success, failure|
      success.json { response.status = 200; render :json => @conference}
    end
  end
  
  def update
    p = (params[:conference] || request.POST)
    
    Array(p[:categories]).map! do |c|
      Category.find_or_create_by_name(c[:name])
    end
    
    conf_clone=@conference.clone
    
    if p["start_date(1i)"].blank? #call from WS
      update_all_attributes(p, @conference)
    else #call from WebUI
      @conference.update_attributes(p)
    end
    
    if conf_clone.start_date!=@conference.start_date or conf_clone.end_date!=@conference.end_date 
      @conference.attendees.each do |user|
        user.notifications.create!(:text=>"Attention! Start or end date of #{@conference.name} was updated by the owner.")
      end
    end
    
    respond_to do |format|
      format.json { @conference.save!; render :json => @conference }
      format.html { update! }
    end
  end
  
  def ical
    conference = Conference.find(params[:id])
    cal = Calendar.new
    cal.event do
      dtstart     conference.start_date
      dtend       conference.end_date
      summary     conference.name
      description conference.description
      location    conference.location
      organizer   conference.creator.fullname+" "+conference.creator.email
      #klass       "PRIVATE"
    end
    cal.event.comments=[conference.venue, conference.howtofind]
    conference.attendees.each do |u|
      if current_user.is_in_contact_with?(u)
        cal.event.comments<<"#{u.username}, #{u.fullname}, #{u.email}"
      else
        cal.event.comments<<"#{u.username}"
      end
    end
    send_data cal.to_ical, :type=>"text/calendar"
  end
  
  def pdf
    conference = Conference.find(params[:id])
    
    doc = Prawn::Document.new
    doc.font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"
    doc.move_down 10
    
    doc.text "Konferenz-Info"
    doc.table [["Start",  conference.start_date],
      ["Ende", conference.end_date],
      ["Zusammenfassung", conference.description],
      ["Ort", conference.location],
      ["Organisator", conference.creator.fullname+" "+conference.creator.email]],
      :horizontal_padding => 10,
      :vertical_padding   => 3,
      :border_width       => 2,
      :position           => :center,
      :column_widths => { 0 => 150, 1 => 200 }
               
    doc.move_down 10
    
    doc.text "Anwesende"
    
    attendees = conference.attendees.map do |a|
      if current_user.is_in_contact_with?(a)
        [a.username, a.fullname, a.email]
      else
        [a.username, nil, nil] 
      end
    end
    
    doc.table attendees,
      :horizontal_padding => 10,
      :vertical_padding   => 3,
      :border_width       => 2,
      :position           => :center,
      :column_widths => { 0 => 100, 1 => 200, 2 => 200 },
      :headers            => ["Username","Name","Email"]
              
    send_data doc.render, :type => "application/pdf"
  end

  def feed
    @conference=Conference.find(params[:id])
    @attendees = @conference.attendees
    puts @attendees.size
    respond_to do |format|
      format.html
      format.rss { render :layout => false } #index.rss.builder
    end
  end


  def invite_via_email
    @conference=Conference.find(params[:id])
    count=0
    params[:contacts].split(/\n/).each do |line|
      line=line.strip
      unless line.blank? and line=~/@/
        password=rand(100000000000000).to_s
        if u=User.create!(:email=>line, :fullname=>"_",  :username=>"invited_by_email_#{rand(100000000000)}", :town=>"_", :country=>"_", :password_confirmation=>password, :password=>password)
          @conference.attendees<<u
          UserMailer.invite(@conference,line.strip, current_user).deliver
          count+=1
        end
      end
    end
    flash[:notice]="#{count} Emails have been sent."
    redirect_to conference_path(@conference)
  end

  private

  def load_conference
    @conference = Conference.find(params[:id])
  end
  
end
