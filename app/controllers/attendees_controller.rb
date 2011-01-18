class AttendeesController < ApplicationController
  respond_to :json
  
  verify :params => [:conference_id]
  verify :params => [:id], :only => [:show]
  verify :params => [:user], :only => [:id]
  
  
  def index
    @attendees = attendees
    
    respond_to do |format|
      format.json { render :json => @attendees }
      format.html { redirect_to "/" } #TODO => change
    end
  end
  
  def create
    attendees << User.find(params[:user][:id])
    attendees.save
    
    respond_to do |format|
      format.json { head 204 }
    end
  end
  
  def delete
    @attendee = attendees.find(params[:id])
    
    respond_to do |format|
      format.json { head 204 }
    end
  end
  
  private
    def attendees
      Conference.find(params[:conference_id]).attendees
    end
end
