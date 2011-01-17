class Admin::AuthenticationsController < Admin::BaseController
  actions :index, :destroy
  respond_to :html
end