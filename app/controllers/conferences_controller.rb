#origin: GM

# class ConferencesController < BaseController
class ConferencesController < InheritedResources::Base
  before_filter :authenticate_user!
  
  respond_to :html, :json
  before_filter :load_conference, :only => [:show, :update]

  verify :params => [:id], :only => [:show, :update]
  
  def show    
    respond_to do |format|
      format.json { render :json => @conference }
      format.html { render } #TODO => change
    end
  end

  def search
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
    @conferences=ConferenceSearcher.do_find opts, current_user
    render :template=>"conferences/index"
  end
  
  def create
    @conference = Conference.new(params[:conference] || request.POST)
    @conference.creator = current_user
    
    create!
  end
  
  def update
    @conference.attributes = (params[:conference] || request.POST)
    
    update!
  end
  

  private

    def load_conference
      @conference = Conference.find(params[:id])
    end
    
end
