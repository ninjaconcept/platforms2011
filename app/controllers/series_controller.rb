#origin GM

#This class manages Series, both for users as well as the webservice

class SeriesController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :require_admin, :except => [:index, :show]
  
  def index
    
    respond_to do |format|
      format.json do
        s = Series.all
        empty_safe(s) { render :json => s }
      end
      format.html do
        super
      end
    end
    
  end
  
  def create
    respond_to do |format|
      format.json do
        p = request.POST
        Array(p[:contacts]).map! do |c|
          User.find_by_username(c[:username])
        end
        s = Series.create!(p)
        render :json => s
      end
      format.html do
        super
      end
    end
    
  end
  
  def show
    respond_to do |format|
      format.json do
        render :json => Series.find(params[:id])
      end
    end
  end
end
