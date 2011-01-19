class MembersController < BaseController
  respond_to :json, :html
  before_filter :authenticate_user!
  
  def index
    @members = User.all.paginate(:per_page => 15, :page => params[:page])
  end
  
  def search
    @members = User
    if params[:search_term]
      term="%#{params[:search_term]}%"
      @members=@members.where("username like ? OR fullname like ? OR town like ? OR country like ?", term, term,term,term)
    end
    if params[:only_non_contacts_members]
      #TODO (m90) @members=@members.where("rcd_status").includes(:rcd_statuses)
    end
    if params[:only_non_rcd_members]
      #TODO (m91)
    end
    if params[:region].to_i!=0
      @members=@members.within(params[:region].to_i, :origin=>current_user)
    elsif params[:region]=="none"
      #do nothing more
    elsif params[:region]=="town"
      @members=@members.where("town=?",current_user.town)
    elsif params[:region]=="country"
      @members=@members.where("country=?",current_user.country)
    end
    @members=@members.paginate(:per_page => 15, :page => params[:page])
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
