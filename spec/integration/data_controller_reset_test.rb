# origin: M

require "spec_helper"

describe DataController do
  context "reset works" do
    before do
      get "/ws/reset", {}, admin_headers
    end
    
    it "should respond with 204" do
      response.status.should == 204
    end
  end
end