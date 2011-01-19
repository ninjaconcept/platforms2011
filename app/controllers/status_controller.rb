class StatusController < ApplicationController
  def index
    all_rcds=RcdStatus.where("(inviter_user_id=? OR invitee_user_id=?)",current_user.id,current_user.id)
    @users_in_contact=all_rcds.where("status='in_contact'")
    @users_with_sent_rcds=all_rcds.where("status='RCD_sent'")
    @users_with_received_rcds=all_rcds.where("status='RCD_received'")
    @attending_conferences=Conference.where("attendances.user_id=?",current_user.id).join(:attendances)
  end
end
