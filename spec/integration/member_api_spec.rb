# origin: M

require "spec_helper"

describe MembersController do
  context "Registration of new user" do
    context "with valid data" do
      before do
        @user = Factory.build(:user)
        payload = @user.attributes
        payload[:password] = "super-secrit"
        post "/ws/members/", payload.to_json, {"CONTENT_TYPE" => "application/json"}
      end
      
      it "should return 200" do
        response.status.should == 200
      end
      
      it "should have created a new user" do
        u = JSON.parse(response.body)
        User.find_by_username(u[:username])
      end
    end

    context "with invalid data" do
      before do
        @user = Factory.build(:user) #has no password
        post "/ws/members/", @user.to_json, {"CONTENT_TYPE" => "application/json"}
      end

      it "should return 400" do
        response.status.should == 400
      end
    end
  end

  context "display of a user" do

  end
end
