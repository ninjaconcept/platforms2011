# origin: M

require "spec_helper"

describe MembersController do
  context "Registration of new user" do
    context "with valid data" do
      before do
        @user = Factory.build(:user)
        payload = @user.attributes
        payload[:password] = "super-secrit"
        post "/ws/members/", payload.to_json, json_headers
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
        post "/ws/members/", @user.to_json, json_headers
      end

      it "should return 400" do
        response.status.should == 400
      end
    end
  end
  
  
  context "single user" do
    context "retrieval of self" do
      before do
        get "/ws/members/sjobs", {}, json_headers
      end
      
      it "should return 200" do
        response.status.should == 200
      end
    end
    
    context "change of self" do
      before do
        put "/ws/members/sjobs", {:email => "woz.hacked.you@example.com"}.to_json, json_headers
      end
      
      it "should return 200" do
        response.status.should == 200
      end
      
      it "should have changed steve" do
        u = User.find_by_username("sjobs")
        u.email = "woz.hacked.you@example.com"
      end
    end
    
    context "change of other" do
      before do
        put "/ws/members/swozniak", {:email => "sjobs.hacked.you@example.com"}.to_json, json_headers
      end
      
      it "should return 403" do
        response.status.should == 403
      end
    end
    
    context "change with wrong key" do
      before do
        put "/ws/members/sjobs", {:emehl => "woz.hacked.you@example.com"}.to_json, json_headers
      end
      
      it "should return 400" do
        response.status.should == 400
      end
    end
    
    context "concurrent change" do
      before do
        u1 = User.find_by_username("sjobs")
        u2 = u1.clone
        u2.email = "sjobs.tried.to.hack.himself@example.com"
        u1.email = "sjobs.hacked.himself@example.com"
        u1.save
        
        put "ws/members/sjobs", u2.to_json(:full => true), json_headers
      end
      
      it "should return 409" do
        response.status.should == 409
      end
    end
    
    
    context "change non existing user" do
      before do
        put "/ws/members/ibo", {:emehl => "woz.hacked.you@example.com"}.to_json, json_headers
      end
      
      it "should return 404" do
        response.status.should == 404
      end
    end
  end
end
