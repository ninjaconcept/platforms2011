class MembersController < ApplicationController
  respond_to :json
  
  def create
    p = params[:user] || request.POST
    p[:password_confirmation] = p[:password] 
    u = User.create!(p)
        
    respond_to do |format|
      format.json { render :json => u }
    end
  end
  
  def show
    respond_to do |format|
      format.json { render :json => User.find_by_username(params[:username]) }
    end
  end
end
