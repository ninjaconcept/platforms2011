class ConferencesController < InheritedResources::Base
  respond_to :html, :json
  verify :params => [:conference], :only => [:create, :update]
  verify :params => [:id], :only => [:show, :update]
  
  def show
    @conference = Conference.find(params[:id])
    
    respond_to do |format|
      format.json { render :json => @conference }
      format.html { render } #TODO => change
    end
  end
  
  def create
    @conference = Conference.create(params[:conference])
        
    respond_to do |format|
      format.json { render :json => @conference }
      format.html { redirect_to "/" } #TODO => change
    end
  end
  
  def update
    @conference = Conference.find(params[:id])
    @conference.update_attributes()
  end
end
