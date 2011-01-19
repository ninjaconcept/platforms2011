class NotificationsController < InheritedResources::Base
  
  def update
    n=current_user.notifications.find_by_id(params[:id])
    n.update_attributes!(:read=>params[:read])
    render :update do |page|
      #page.hide "notification_#{n.id}" #TODO: jquery einbinden
      page<<"$('#notification_#{n.id}').hide()"
    end
  end

  
end
