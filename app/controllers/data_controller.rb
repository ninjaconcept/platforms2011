class DataController < ApplicationController
  def factory_defaults
    FactoryDefaults.import
  end
end
