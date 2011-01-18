class AttendeesController < ApplicationController
  respond_to :json
  
  verify :params => [:conference_id]
  verify :params => [:id], :only => [:show]
  verify :params => [:user], :only => [:id]
    
  def index
    @attendees = attendees
    
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
    attendees << User.find_by_username(username || request.POST["username"])
    
    respond_to do |format|
      format.json { head 204 }
    end
  end
  
  def destroy
    @attendee = attendees.find_by_username(params[:username])
    attendees.delete(@attendee)
    
    respond_to do |format|
      format.json { head 204 }
    end
  end
  
  private
    def attendees
      Conference.find(params[:conference_id]).attendees
    end
end
