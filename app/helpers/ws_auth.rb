module WsAuth
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