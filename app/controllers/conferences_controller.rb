#origin: GM

class ConferencesController < InheritedResources::Base
  before_filter :ws_auth 
  
  respond_to :html, :json
  before_filter :load_conference, :only => [:show, :update]
  before_filter :authenticate_user!
  
  verify :params => [:id], :only => [:show, :update]
  
  def show    
    respond_to do |format|
      format.json { render :json => @conference }
      format.html { render } #TODO => change
    end
  end


  def search
    opts={}
    opts=params
    @conferences=ConferenceSearcher.do_find opts
  end

  def create
    @conference = Conference.new(params[:conference] || request.POST)
    @conference.creator=current_user
    @conference.save!
        
    respond_to do |format|
      format.json { render :json => @conference }
      format.html { redirect_to "/" } #TODO => change
    end
  end
  
  def update
    @conference.attributes = (params[:conference] || request.POST)
    @conference.save!
    
    respond_to do |format|
      format.json { render :json => @conference }
      format.html { render } #TODO => change
    end
  end
  
  def load_conference
    @conference = Conference.find(params[:id])
  end
end
