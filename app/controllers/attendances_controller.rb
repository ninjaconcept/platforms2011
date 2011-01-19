class AttendancesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  respond_to :json, :js
  
  verify :params => [:conference_id]
  verify :params => [:id], :only => [:show]
  verify :params => [:user], :only => [:id]
    
  def index
    @attendances = attendances
    
    respond_to do |format|
      format.json do
        empty_safe(@attendances) do
          render :json => @attendances
        end
      end
      format.html { redirect_to "/" } #TODO => change
    end
  end
  
  def create
    username = params[:user][:username] if params[:user]
    user = User.find_by_username(username || request.POST["username"])
    
    conference
    
    head 403 and return unless check_user(user)
    
    attendances << Attendance.new(:user => user)
    respond_to do |format|
      # format.json { head 204 }
      format.json do
        if request.xhr?
          render :update do |page|
            page.reload
          end
        else
          head 204 
        end
      end
    end
  end
  
  def destroy
    uid = User.find_by_username(params[:username])
    
    conference
    
    head 403 and return unless check_user(uid)
    
    @attendance = attendances.find_by_user_id(uid)
    @attendance.delete
    
    respond_to do |format|
      format.json { head 204 }
    end
  end
  
  private
    def conference
      Conference.find(params[:conference_id])
    end
  
    def attendances
      conference.attendances
    end
    
    def check_user(user)
      user == current_user
    end
end
