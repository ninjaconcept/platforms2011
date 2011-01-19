# origin: M

require "spec_helper"

describe DataController do
  context "factorydefaults works" do
    before do
      get "/ws/factorydefaults", {}, admin_headers
    end
    
    it "should respond with 204" do
      response.status.should == 204
    end
  end

end