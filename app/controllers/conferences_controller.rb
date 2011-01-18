class ConferencesController < InheritedResources::Base
  respond_to :html, :json
  
  def show
    @conference = Conference.find(params[:id])
    
    respond_to do |format|
      format.json { render :json => @conference }
      format.html { render } #TODO => change
    end
  end
  
  def create
    raise MissingData unless params[:conference]
    @conference = Conference.create(params[:conference])
        
    respond_to do |format|
      format.json { render :json => @conference }
      format.html { redirect_to "/" } #TODO => change
    end
  end
end
