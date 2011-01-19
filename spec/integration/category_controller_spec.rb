# origin: M

require 'spec_helper'

describe CategoriesController do
  
  context "reading category list" do
    before do
      get "/ws/categories", {}, json_headers
    end
    
    it "should return 200" do
      response.status.should == 200
    end
    
    it "should return all categories" do
      res = JSON.parse(response.body)
      res.size.should == Category.count
    end
  end
  
  context "reading single category" do
    before do
      @c = Category.first
      get "/ws/categories/#{@c.id}", {}, json_headers
    end
    
    it "should return 200" do
      response.status.should == 200
    end
    
    it "should return the category" do
      JSON.parse(response.body)["name"].should == @c.name
    end
  end
  
  context 'reading conferences by category' do
    before do
      @c = Category.find_by_name("Technology")
      get "/ws/conferencesbycategory/#{@c.id}", {}, json_headers
    end
    
    it "should return 200" do
      response.status.should == 200
    end
    
    it "should return the conferences" do
      JSON.parse(response.body).size.should == @c.conferences.size
    end
  end
  
  context 'reading conferences by empty category' do
    before do
      @c = Category.find_by_name("Arts")
      get "/ws/conferencesbycategory/#{@c.id}", {}, json_headers
    end
  
    it "should return 204" do
      response.status.should == 204
    end
  end
  
  context "creating category" do
    context "as admin" do
      before do
        @c = Factory.build(:category)
        post "/ws/categories", @c.to_json, admin_headers
      end
      
      it "should return 200" do
        response.status.should == 200
      end
      
      it "should return the category" do
        JSON.parse(response.body)["name"].should == @c.name
      end
      
      it "should have created an object" do
        Category.find_by_name(@c.name).should_not be_nil
      end
    end
    
    context "as non-admin" do
      before do
        @c = Factory.build(:category)
        post "/ws/categories", @c.to_json, json_headers
      end
      
      it "should return 403" do
        response.status.should == 403
      end
    end
  end
  
  context "creating a taken category" do
    before do
      @c = Factory.build(:category)
      @c.name = "Arts"
      post "/ws/categories", @c.to_json, admin_headers
    end
    
    it "should return 400" do
      response.status.should == 400
    end
  end
  
  context "creating a subcategory" do
    before do
      post "/ws/categories", {:name => "test", :parent => {:name => "Arts"}}.to_json, admin_headers
    end
    
    it "should return 200" do
      response.status.should == 200
    end
    
    it "should be a child category" do
      Category.find_by_name("Arts").children.size == 1
    end
  end
end