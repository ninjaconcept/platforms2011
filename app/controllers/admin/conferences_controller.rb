class Admin::ConferencesController < Admin::BaseController
  belongs_to :category, :optional => true
end