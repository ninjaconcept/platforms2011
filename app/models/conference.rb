class Conference < ActiveRecord::Base
  @@per_page = 10 #for will_paginate

  include GeoHelper
  class << self
    include GeoHelper
  end
  
  attr_accessor :just_created

  has_friendly_id :name, :use_slug => true, :approximate_ascii => true
  
  acts_as_mappable acts_as_mappable_hash
  validates_format_of :gps, :with => GPS_REGEX, :allow_blank => true
  
  belongs_to :creator, :class_name=>"User", :foreign_key => 'creator_user_id'

  has_many :attendances, :dependent => :destroy
  has_many :attendees, :through=>:attendances
  
  has_many :category_conferences, :dependent => :destroy
  has_many :categories, :through=>:category_conferences
  
  
<<<<<<< HEAD
  validates_presence_of :name, :start_date, :end_date, :description, :location
  validates_presence_of :categories, :unless => :just_created
=======
  validates_presence_of :name, :start_date, :end_date, :description, :location, :categories
>>>>>>> 2913999cd96eea378419a9f107f82f28d7fe9c14
  
end
