# origin: M

require "spec_helper"

describe SeriesController do
  context "The list of all series" do
    before do
      get "/ws/series/", {}, json_headers
    end
    
    it "should return 200" do
      response.status.should == 200
    end
  end
  
  context "create a new series" do
    before do
      s = {
        :name => "Monsters of Computer Science",
        :contacts => [
          {:username => "edijkstra"},
          {:username => "aturing"}
        ]
      }
      
      post "/ws/series", s.to_json, admin_headers
    end
    
    it "should return 200" do
      response.status.should == 200
    end
    
    it "should be in the database" do
      Series.find_by_name("Monsters of Computer Science").should_not be_nil
    end
    
    it "should have contacts" do
      Series.find_by_name("Monsters of Computer Science").contacts.size.should == 2
    end
  end
  
  context "show existing series" do
    before do
      get "/ws/series/1", {}, json_headers
    end
    
    it "should return 200" do
      response.status.should == 200
    end
  end
  
  context "show non-existing series" do
    before do
      get "/ws/series/100000000", {}, json_headers
    end
    
    it "should return 404" do
      response.status.should == 404
    end
  end
end