#origin: GM

class ConferencesController < InheritedResources::Base
  respond_to :html, :json
  before_filter :load_conference, :only => [:show, :update]
  verify :params => [:id], :only => [:show, :update]
  
  def show    
    respond_to do |format|
      format.json { render :json => @conference }
      format.html { render } #TODO => change
    end
  end
  
  def create
    @conference = Conference.create!(params[:conference] || request.POST)
        
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
