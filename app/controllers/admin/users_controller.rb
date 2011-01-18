class Admin::UsersController < Admin::BaseController
  before_filter :require_admin
end