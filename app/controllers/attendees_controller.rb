class AttendancesController < ApplicationController
  respond_to :json
  
  verify :params => [:conference_id]
  verify :params => [:id], :only => [:show]
  verify :params => [:user], :only => [:id]
    
  def index
    @attendances = attendances
    
    respond_to do |format|
      format.json do
        empty_safe(@attendees) do
          render :json => @attendees
        end
      end
      format.html { redirect_to "/" } #TODO => change
    end
  end
  
  def create
    username = params[:user][:username] if params[:user]
    attendances << User.find_by_username(username || request.POST["username"])
    respond_to do |format|
      format.json { head 204 }
    end
  end
  
  def destroy
    @attendances = attendances.find_by_username(params[:username])
    attendances.delete(@attendee)
    respond_to do |format|
      format.json { head 204 }
    end
  end
  
  private
  def attendances
    Conference.find(params[:conference_id]).attendances
  end
end
