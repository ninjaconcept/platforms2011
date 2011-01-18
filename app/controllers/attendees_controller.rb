class AttendancesController < ApplicationController
  respond_to :json
  
  verify :params => [:conference_id]
  verify :params => [:id], :only => [:show]
  verify :params => [:user], :only => [:id]
  
  
  def index
    @attendances = attendances
    
    respond_to do |format|
      format.json { render :json => @attendances }
      format.html { redirect_to "/" } #TODO => change
    end
  end
  
  def create
    attendances << User.find(params[:user][:id])
    attendances.save
    
    respond_to do |format|
      format.json { head 204 }
    end
  end
  
  def delete
    @attendee = attendances.find(params[:id])
    
    respond_to do |format|
      format.json { head 204 }
    end
  end
  
  private
    def attendances
      Conference.find(params[:conference_id]).attendances
    end
end
