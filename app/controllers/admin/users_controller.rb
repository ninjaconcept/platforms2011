#origin GM

class Admin::UsersController < Admin::BaseController
  
  def index
    @search_term = params[:user][:search_term] if params[:user]
    term = "%#{@search_term}%"

    @users = User.where("username LIKE ? OR email LIKE ? OR fullname LIKE ?", term, term, term)
    
    logger.debug "Search: #{params[:user][:search_term]}" if params[:user]
    
    index!
  end
  
end