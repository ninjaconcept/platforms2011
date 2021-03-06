#origin GM

# This class provides the interface for admins to create series

class Admin::SeriesController < Admin::BaseController
  def update
    update! do |success, failure|
      success.html { 
        redirect_to admin_series_index_path 
      }
    end
  end
  
  def create
    create! do |success, failure|
      success.html { 
        redirect_to admin_series_index_path 
      }
    end
  end
end