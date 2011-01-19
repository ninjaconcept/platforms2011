class Admin::SeriesController < Admin::BaseController
  belongs_to :category, :optional => true
end