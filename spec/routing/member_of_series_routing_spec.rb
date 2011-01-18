require "spec_helper"

describe MemberOfSeriesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/member_of_series" }.should route_to(:controller => "member_of_series", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/member_of_series/new" }.should route_to(:controller => "member_of_series", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/member_of_series/1" }.should route_to(:controller => "member_of_series", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/member_of_series/1/edit" }.should route_to(:controller => "member_of_series", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/member_of_series" }.should route_to(:controller => "member_of_series", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/member_of_series/1" }.should route_to(:controller => "member_of_series", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/member_of_series/1" }.should route_to(:controller => "member_of_series", :action => "destroy", :id => "1")
    end

  end
end
