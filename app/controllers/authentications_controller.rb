#origin GM

#This class manages logins, both for users as well as the webservice

class AuthenticationsController < InheritedResources::Base
  actions :index, :create, :destroy
  
  def index
    logger.debug "***** !!!!! Current user: #{current_user.inspect}"
    @authentications = current_user.authentications if current_user
  end
  
  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:success] = "Authentication via #{omniauth['provider']} was successful! We automatically logged you in."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:success] = "Authentication via #{auth['provider']} was successful!"
      redirect_to authentications_path
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:success] = "We automatically created an account based on your #{omniauth['provider']} settings and logged you in!"
        sign_in_and_redirect(:user, authentication.user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_path
      end
    end
  end
  
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    destroy!
  end
  
end
