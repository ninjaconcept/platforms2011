class Admin::ConferencesController < Admin::BaseController
  belongs_to :category, :optional => true
  belongs_to :series, :optional => true
end