#origin GM

# This class acts as a base class for all controllers in the Admin namespace

class Admin::BaseController < BaseController
  before_filter :authenticate_user!
  before_filter :require_admin
  
  def create
    create! do |success, failure|
      success.html { redirect_to collection_path }
    end
  end
  
  def update
    update! do |success, failure|
      success.html { redirect_to collection_path }
    end
  end
  
end


