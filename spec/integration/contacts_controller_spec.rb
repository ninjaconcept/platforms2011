# #origin: M

require 'spec_helper'

describe ContactsController do
  
  context "authenticated" do
    before do
      @headers = authed_headers({"CONTENT_TYPE" => "application/json"})
    end
    
    context "reading" do
      before do
        @user = User.find_by_username("swozniak")
        User.all(:limit => 5).each do |other| 
          RcdStatus.send_rcd(@user, other)
        end
        @user.rcd_statuses.first.accept!
      end
      
      it "should show all rcs for owner" do
        get "/ws/members/#{@user.username}/contacts", {}, authed_headers({"CONTENT_TYPE" => "application/json"}, "swozniak", "kzr")
        response.status.should == 200
        JSON.parse(response.body).size.should == 5
      end
      
      it "should read all rds with in_contact for different user" do
        get "/ws/members/#{@user.username}/contacts", {}, authed_headers({"CONTENT_TYPE" => "application/json"})
        response.status.should == 200
        JSON.parse(response.body).size.should == 1
      end
    end
    
    context "writing" do
      before do
        @user = User.find_by_username("edijkstra")
        User.all(:limit => 5).each do |other| 
          post "/ws/members/#{other.username}/contacts", {:positive => true}.to_json, authed_headers({"CONTENT_TYPE" => "application/json"}, "edijkstra", "kzr")
        end
      end
      
      it "should be able to accept" do
        reset!
        post "/ws/members/edijkstra/contacts", {:positive => true}.to_json, authed_headers({"CONTENT_TYPE" => "application/json"}, "sballmer", "kzr")
        response.status.should == 204
      end
      
      context "errornous write" do
        before do
          post "/ws/members/swozniac/contacts", {:wrong_key => true}.to_json, authed_headers({"CONTENT_TYPE" => "application/json"}, "edijkstra", "kzr")
        end
        
        it "should return 400" do
          response.status.should == 400
        end
      end
    end
  end
end