class StatusController < ApplicationController
  def index
    all_rcds=RcdStatus.where("(inviter_user_id=? OR invitee_user_id=?)",current_user.id,current_user.id)
    all_rcds_as_inviter=RcdStatus.where("(inviter_user_id=?)",current_user.id)
    all_rcds_as_invitee=RcdStatus.where("(invitee_user_id=?)",current_user.id)
    @users_in_contact=all_rcds.where("status='in_contact'")
    @sent_rcds=all_rcds_as_inviter.where("status='sent'")
    @received_rcds=all_rcds_as_invitee.where("status='sent'")
    @attending_conferences=Conference.where("attendances.user_id=?",current_user.id).includes(:attendances)
    @notifications=current_user.notifications.where("`read`=?",false)
  end
end
