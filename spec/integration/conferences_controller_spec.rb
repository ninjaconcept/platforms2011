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
      context "with a series" do
        before do
          f = Factory.build(:new_conference)
          f.series = Series.find_by_name("Chaos Communication Congress")
          reset!
          post "/ws/conferences", f.to_json(:include => [:series, :categories] ), authed_headers({"CONTENT_TYPE" => "application/json"}, "kzuse", "kzr")
        end
        
        it "should create the conference" do          
          response.status.should == 200
        end
      end
      
      context "with a series that does not belong to me" do
        before do
          f = Factory.build(:new_conference)
          f.series = Series.find_by_name("ICSE")
          reset!
          
          post "/ws/conferences", f.to_json(:include => :series), authed_headers({"CONTENT_TYPE" => "application/json"}, "kzuse", "kzr")
        end
        
        it "should not create the conference" do
          puts response.inspect
          response.status.should == 403
        end

      end
      
      context "with correct data" do
        before do
          post "/ws/conferences", Factory.build(:new_conference).to_json(:include => :categories), @headers
        end
        
        it "should create the conference" do
          response.status.should == 200
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
            @c.name = "changed"
            
            put "ws/conferences/#{@c.id}", @c.to_json(:include => :categories), @headers
          end
          
          it "should return 200" do
            response.status.should == 200
          end
          
          it "should have changed the object" do
            @c.reload
            @c.name.should == "changed"
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
          
          put "ws/conferences/#{@c.id}", @c2.to_json(:include => :categories), @headers
        end
        
        it "should return 409" do
          response.status.should == 409
        end
      end
      
      context "search" do
        context "with results" do
          before do
            get "/ws/search/cat:Technology", {}, @headers
          end
          
          it "should return 200" do
            response.status.should == 200
          end
          
          it "should return 10 items" do
            JSON.parse(response.body).size.should == 6
          end
        end
        
        context "without results" do
          before do
            get "/ws/search/cat:Arts", {}, @headers
          end
          
          it "should return 204" do
            response.status.should == 204
          end
        end
      end
    end
  end
  
  context "unauthenticated" do
    
  end
end