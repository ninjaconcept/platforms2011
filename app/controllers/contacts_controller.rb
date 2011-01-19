class ContactsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json
  
  def index
    u = User.find_by_username(params[:username])
    @rcd_list = u.rcd_statuses
    
    @rcd_list.reject! {|s| s.status != "in_contact"} unless u == current_user
    
    respond_to do |format|
      format.json { empty_safe(@rcd_list) { render :json => @rcd_list } }
    end
  end
  
  def add
    u = User.find_by_username(params[:username])
    rcd = RcdStatus.for_users(u, current_user)
    
    raise UpdateFailed if params[:positive].nil?
    
    if rcd
      status = rcd.status_for_user(current_user)
      
      if status == "RCD_received" && params[:positive]
        rcd.accept!
      else status == "RCD_received" && params![:positive]
        rcd.reject!
      end
    else
      RcdStatus.send_rcd(@current_user, u)
    end
    
    respond_to do |format|
      format.json { head 204 }
    end
  end
end
