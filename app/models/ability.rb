class Ability
  include CanCan::Ability
  
  def initialize(user, controller)
    user ||= User.new # guest user
    @current_controller = controller
    
    if user.is_admin?
      can :manage, :all
    else
      
    end
    
    #defaults
    
  end
  
  def parent
    @current_controller.send(:parent)
  end
  
end
