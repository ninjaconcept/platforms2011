class MembersController < BaseController
  respond_to :json, :html
  before_filter :authenticate_user!
  
  def index
    @members = User.all.paginate(:per_page => 15, :page => params[:page])
  end
  
  def create
    p = params[:user] || request.POST
    p[:password_confirmation] = p[:password] 
    u = User.create!(p)
        
    respond_to do |format|
      format.json { render :json => u }
    end
  end
  
  def show
    respond_to do |format|
      format.json { render :json => User.find_by_username(params[:username]) }
      format.html {
        @member = User.find(params[:id])
      }
    end
  end
  
  def update
    p = params[:user] || request.POST
    u = User.find_by_username!(params[:username])
    
    if u == current_user
      
      update_all_attributes(p, u)
      
      respond_to do |format|
        format.json { render :json => u }
      end
    else
      respond_to do |format|
        format.json { head 403 }
      end
    end
  end
end
