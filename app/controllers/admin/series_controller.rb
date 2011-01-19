class Admin::SeriesController < Admin::BaseController
  def update
    update! do |success, failure|
      success.html { 
        redirect_to admin_series_index_path 
      }
    end
  end
end