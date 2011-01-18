class AttendancesController < ApplicationController
  respond_to :json
  
  verify :params => [:conference_id]
  verify :params => [:id], :only => [:show]
  verify :params => [:user], :only => [:id]
    
  def index
    @attendances = attendances
    
    respond_to do |format|
<<<<<<< HEAD
      format.json { render :json => @attendances }
=======
      format.json do
        empty_safe(@attendees) do
          render :json => @attendees
        end
      end
>>>>>>> 134eb7f9be9fb724b2c32c80feb3f989977ed1f5
      format.html { redirect_to "/" } #TODO => change
    end
  end
  
  def create
<<<<<<< HEAD
    attendances << User.find(params[:user][:id])
    attendances.save
=======
    username = params[:user][:username] if params[:user]
    attendees << User.find_by_username(username || request.POST["username"])
>>>>>>> 134eb7f9be9fb724b2c32c80feb3f989977ed1f5
    
    respond_to do |format|
      format.json { head 204 }
    end
  end
  
<<<<<<< HEAD
  def delete
    @attendee = attendances.find(params[:id])
=======
  def destroy
    @attendee = attendees.find_by_username(params[:username])
    attendees.delete(@attendee)
>>>>>>> 134eb7f9be9fb724b2c32c80feb3f989977ed1f5
    
    respond_to do |format|
      format.json { head 204 }
    end
  end
  
  private
    def attendances
      Conference.find(params[:conference_id]).attendances
    end
end
