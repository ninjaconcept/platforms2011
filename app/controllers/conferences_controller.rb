class ConferencesController < InheritedResources::Base
  respond_to :html, :json
  
  def show
    @conference = Conference.find(params[:id])
    case request.format
    when :json
      render :json => @conference
    when :html
    end
  end
  
  def create
    @conference = Conference.create(params[:conference])
        
    respond_to do |format|
      format.json { render :json => @conference }
      format.html { redirect_to "/"} #TODO => change
    end
  end
end
