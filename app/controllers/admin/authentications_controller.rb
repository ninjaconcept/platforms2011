#origin GM

# This Controller allows administrators to delete user authentication

class Admin::AuthenticationsController < Admin::BaseController
  actions :index, :destroy
  respond_to :html
end