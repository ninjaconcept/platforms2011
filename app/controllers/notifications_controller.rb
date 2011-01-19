class NotificationsController < InheritedResources::Base
  
  def update
    n=current_user.notifications.find_by_id(params[:id])
    n.update_attributes!(:read=>params[:read])
    render :update do |page|
      #page.hide "notification_#{n.id}" #TODO: jquery einbinden
      page<<"$('#notification_#{n.id}').hide()"
    end
  end

  def create
    other_user=User.find(params[:user_id])
    conf=Conference.find(params[:conference_id])
    other_user.notifications.create!(:text=>"Invitation from #{current_user.fullname}: Hey, do you like to come to #{conf.name}? It will be pretty cool there.")
    render :update do |page|
      page<<"$('#user_#{other_user.id}').replaceWith('Ok, the user #{other_user.fullname} got an invitation notification')"
    end
  end

  
end
