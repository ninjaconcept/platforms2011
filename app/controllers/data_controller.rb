class DataController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin
  
  def factory_defaults
    FactoryDefaults.reset
    FactoryDefaults.import
    head 204
  end
  
  def reset
    FactoryDefaults.reset
    head 204
  end
end
