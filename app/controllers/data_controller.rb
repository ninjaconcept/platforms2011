class DataController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin
  
  def factory_defaults
    FactoryDefaults.reset
    FactoryDefaults.import
  end
  
  def reset
    FactoryDefaults.reset
  end
end
