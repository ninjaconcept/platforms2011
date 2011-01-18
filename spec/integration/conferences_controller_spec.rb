# #origin: M

require 'spec_helper'

describe ConferencesController do
  before do
    @c = Factory.create(:conference)
  end
  
  context "authenticated" do
    before do
      @headers = authed_headers({"CONTENT_TYPE" => "application/json"})
    end
    
    context "searching conferences" do
      context "with correct data" do
        before do
          post "/conferences/search?query=from:20091131 until:20110118"
        end
      end
    end
    
    context "creating a new conference" do
    
      context "with correct data" do
        before do
          post "/ws/conferences", Factory.build(:new_conference).to_json, @headers
        end
        
        it "should create the conference" do
          puts response.inspect
          response.should be_success
        end
        
        it "should have created an instance" do
          c = Conference.find_by_name("FunConf")
          c.name.should == "FunConf"
        end
      end
      
      context "with invalid object" do
        before do
          post "/ws/conferences", {"hoge" => "fuge"}.to_json, @headers
        end
          
        it "should return 400" do
          response.status.should == 400
        end
      end
      
      context "with broken json" do
        before do
          post "/ws/conferences", "this,is,no,js\"//\"on", @headers
        end
          
        it "should return 400" do
          response.status.should == 400
        end
      end
    end
    
    context "reading conferences" do
      context "existing conferences" do
        before do
          get "ws/conferences/#{@c.id}", {}, @headers
        end
        
        it "should return 200" do
          response.status.should == 200
        end
      end
      
      context "non-existing conferences" do
        before do
          get "ws/conferences/100000000", {}, @headers
        end
        
        it "should return 404" do
          response.status.should == 404
        end
      end
    end
    
    context "changing" do
      context "existing conferences" do
        context "with valid data" do
          before do
            @c2 = @c.clone
            @c2.name = "changed"
            
            put "ws/conferences/#{@c.id}", @c2.to_json, @headers
          end
          
          it "should return 200" do
            response.status.should == 200
          end
          
          it "should have changed the object" do
            @c.reload
            @c.name.should == @c2.name
          end
        end
        
        context "with in valid object" do
          before do
            put "ws/conferences/#{@c.id}", {"hoge" => "fuge"}.to_json, @headers
          end
          
          it "should return 400" do
            response.status.should == 400
          end
        end
      end
      
      context "non-existing conferences" do
        before do
          put "ws/conferences/10000000", @c2.to_json, @headers
        end
        
        it "should return 404" do
          response.status.should == 404
        end
      end
      
      context "conflicting change" do
        before do
          @c2 = @c.clone
          @c.name = "change1"
          @c.save
          @c2.name = "change2"
          
          put "ws/conferences/#{@c.id}", @c2.to_json, @headers
        end
        
        it "should return 409" do
          response.status.should == 409
        end
      end
    end
  end
  
  context "unauthenticated" do
    
  end
end