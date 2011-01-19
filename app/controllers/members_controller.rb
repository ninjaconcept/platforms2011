#origin GM

class MembersController < BaseController
  respond_to :json, :html
  before_filter :authenticate_user!
  
  def index
    @members = User.all.paginate(:per_page => 15, :page => params[:page])
  end
  
  def search
    @select_options=[['worldwide', 'none'], ['50km', '50'], ['500km', '500'], ['2000km', '2000'], ['5000km', '5000']]
    @select_options<<[current_user.town, 'town'] if current_user.town
    @select_options<<[current_user.country, 'country'] if current_user.country
    @members = User
    unless params[:search_term].blank?
      term="%#{params[:search_term]}%"
      #some crazy sql for M102:
      @members=@members.where("username like ? OR (fullname like ? AND (((received_statuses_users.inviter_user_id=?) OR (rcd_statuses.invitee_user_id=?)) AND ((received_statuses_users.status='in_contact') OR (rcd_statuses.status='in_contact')) ))", term, term, current_user.id, current_user.id)
      @members=@members.includes(:sent_statuses)
      @members=@members.includes(:received_statuses)
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
      format.json do
        u = User.find_by_username(params[:uname]) 
        if (u == current_user) || u.is_in_contact_with?(current_user) 
          render :text => u.to_json(:full => true)
        else
          render :json => u
        end
      end
      format.html {
        @member = User.find(params[:id])
      }
    end
  end
  
  def update
    p = params[:user] || request.POST
    u = User.find_by_username!(params[:uname])
    
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
