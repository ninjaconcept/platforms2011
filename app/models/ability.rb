#origin GM

class Ability
  include CanCan::Ability
  
  def initialize(user, controller)
    user ||= User.new # guest user
    @current_controller = controller
    
    if user.is_admin?
      can :manage, :all
    else
      can :manage, [Conference], :creator_user_id => user.id
      can :manage, Series do |serie|
        serie.contacts.include? user
      end
      can :read, Conference
      can :read, User
      can :read, Series
    end
    
    #defaults
    can :read, [Conference, User]
  end
  
  def parent
    @current_controller.send(:parent)
  end
  
end
