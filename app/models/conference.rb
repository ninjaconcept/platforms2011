class Conference < ActiveRecord::Base
  include GeoHelper
  class << self
    include GeoHelper
  end
  
  acts_as_mappable acts_as_mappable_hash
  validates_format_of :gps, :with => GPS_REGEX, :allow_blank => true
  
  belongs_to :creator, :class_name=>"User"
  
end
