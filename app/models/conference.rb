class Conference < ActiveRecord::Base
  @@per_page = 10 #for will_paginate

  include GeoHelper
  class << self
    include GeoHelper
  end
  
  acts_as_mappable acts_as_mappable_hash
  validates_format_of :gps, :with => GPS_REGEX, :allow_blank => true
  
  belongs_to :creator, :class_name=>"User"
  has_and_belongs_to_many :attendees, :join_table => 'attendees', 
<<<<<<< HEAD
    :class_name => "User", :uniq => true
  has_many :category_conferences
  has_many :categories, :through=>:category_conferences
=======
                          :class_name => "User", :uniq => true

>>>>>>> 826a1bfc6705801eff4f5b44ad8db4965c39e197
end
