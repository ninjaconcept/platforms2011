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
    status = u.received_statuses

    if status && params[:positive]
      status.accept!
    elsif status && !params[:positive]
      status.reject!
    else
      RcdStatus.send_rcd(@current_user, u)
    end
    
    respond_to do |format|
      format.json { head 204 }
    end
  end
end
