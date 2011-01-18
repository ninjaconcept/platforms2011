#origin GM

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from(ActiveRecord::UnknownAttributeError){ |e| error_response(400, e) }
  rescue_from(ActiveRecord::RecordInvalid){ |e| error_response(400, e) }
  rescue_from(ActiveRecord::RecordNotFound){ |e| error_response(404, e) }
  rescue_from(ActiveRecord::StaleObjectError){ |e| error_response(409, e) }
  
  #cancan  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied. #{exception}"
    redirect_to root_url
  end
  
  def current_ability
     #puts "!!! set current_ability controller: #{self} , parent: #{self.send(:parent) if self.send(:parent?)}"
     Ability.new(current_user, self) # instead of Ability.new(current_user)
  end
  
  def is_admin?
    current_user.is_admin? #rescue false
  end
  
  protected

    def require_admin
      unless current_user && is_admin?
        flash[:error] = "You are not allowed to access this page. Please contact your admin if necessary!"
        redirect_to root_path
        return false
      end
    end
    
    def permission_denied    
      flash[:error] = "You are not allowed to access this page. Please contact your admin if necessary!"
  
      respond_to do |format|
        format.html { redirect_to admin_root_path }
        format.xml  { head :unauthorized }
        format.js   { head :unauthorized }
      end
    end
  
  private

    # Overwriting the sign_out redirect path method
    def after_sign_out_path_for(resource_or_scope)
      root_path
    end
    
    def error_response(status, exception)
      respond_to do |format|
        format.html { "TODO: whatever" }
        format.any  { head status } # only return the status code
      end
    end
    
    def empty_safe(obj)
      if obj.empty?
        head 204
      else
        yield
      end
    end
    
    def ws_auth
      username, password = decode_credentials(request)

      u = User.find_by_username(username)
      if u.valid_password?(password)
        @current_user = u
      else
        head 401
        false
      end
    end

    def decode_credentials(request)
      return *ActiveSupport::Base64.decode64(request.authorization.split(' ', 2).last || '').split(/:/)
    end
end
