#origin GM

class DataController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin
  
  def reset
    FactoryDefaults.reset
    FactoryDefaults.create_admin
    
    head 204
  end
  
  def factory_defaults
    FactoryDefaults.reset
    FactoryDefaults.import
    
    head 204
  end
end
