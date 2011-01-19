#origin: GM

#require 'icalendar'

class ConferencesController < BaseController
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
      cal.event.comments<<"#{u.username}, #{u.fullname}, #{u.email}"
    end
    send_data cal.to_ical, :type=>"text/calendar"
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


  private

  def load_conference
    @conference = Conference.find(params[:id])
  end

  
end
