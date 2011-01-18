#origin: M

require 'spec_helper'

describe AttendeesController do
  context "reading attendees" do
    context "all users of a conference with users" do
      before do
        get "/ws/conferences/1/attendees"
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
        get "/ws/conferences/2/attendees"
      end
      
      it "should return 204" do
        response.status.should == 204
      end
    end
    
    context "all users of a non existing conference" do
      before do
        get "/ws/conferences/10000000/attendees"
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
        post "/ws/conferences/2/attendees", @user.to_json, {"CONTENT_TYPE" => "application/json"}
      end
      
      it "should return 204" do
        response.status.should == 204
      end
      
      it "should create a conference attendance" do
        Conference.find(2).attendees.should include(@user)
      end
    end
    
    context "for a non existing conference" do
      before do
        get "/ws/conferences/10000000/attendees"
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
        @conference.attendees << @user
        delete "/ws/conferences/#{@conference.id}/attendees/#{@user.username}"
      end
      
      it "should return 204" do
        response.status.should == 204
      end
      
      it "should delete the user" do
        @conference.reload
        @conference.attendees.should_not include(@user)
      end
    end
    
    context "for a non existing conference" do
      before do
        @user = User.first
        delete "/ws/conferences/10000000/attendees/#{@user.username}"
      end
      
      it "should return 404" do
        response.status.should == 404
      end
    end
    
  end
  
end
