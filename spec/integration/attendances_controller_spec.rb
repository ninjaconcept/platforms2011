#origin: M

require 'spec_helper'

describe AttendancesController do
  context "reading attendances" do
    context "all users of a conference with users" do
      before do
        get "/ws/conferences/1/attendances"
      end
      
      it "should return 200" do
        response.status.should == 200
      end
      
      it "should return an JSON array" do
        JSON.parse(response.body).should be_a_kind_of(Array)
      end
    end
    
    context "all users of a conference without users" do
      before do
        get "/ws/conferences/2/attendances"
      end
      
      it "should return 204" do
        response.status.should == 204
      end
    end
    
    context "all users of a non existing conference" do
      before do
        get "/ws/conferences/10000000/attendances"
      end
      
      it "should return 404" do
        response.status.should == 404
      end
    end
  end
  
  context "creating attendances" do
    context "for an existing conference" do
      before do
        @user = User.first
        post "/ws/conferences/2/attendances", @user.to_json, {"CONTENT_TYPE" => "application/json"}
      end
      
      it "should return 204" do
        response.status.should == 204
      end
      
      it "should create a conference attendance" do
        conf = Conference.find(2)
        conf.attendances.find_by_user_id(@user).should_not be_nil
      end
    end
    
    context "for a non existing conference" do
      before do
        get "/ws/conferences/10000000/attendances"
      end
      
      it "should return 404" do
        response.status.should == 404
      end
    end
    
  end
  
  context "deleting attendances" do
    context "for an existing conference" do
      before do
        @user = User.first
        @conference = Conference.find(2)
        @conference.attendances << Attendance.new(:user => @user)
        @conference.save
        delete "/ws/conferences/#{@conference.id}/attendances/#{@user.username}"
      end
      
      it "should return 204" do
        response.status.should == 204
      end
      
      it "should delete the user" do
        @conference.reload
        @conference.attendances.should_not include(@user)
      end
    end
    
    context "for a non existing conference" do
      before do
        @user = User.first
        delete "/ws/conferences/10000000/attendances/#{@user.username}"
      end
      
      it "should return 404" do
        response.status.should == 404
      end
    end
    
  end
  
end
