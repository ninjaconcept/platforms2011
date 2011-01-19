class MembersController < BaseController
  respond_to :json, :html
  
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
  
end
