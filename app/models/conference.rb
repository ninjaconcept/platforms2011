class Conference < ActiveRecord::Base
  @@per_page = 10 #for will_paginate

  include GeoHelper
  class << self
    include GeoHelper
  end
  
  has_friendly_id :name, :use_slug => true, :approximate_ascii => true
  
  acts_as_mappable acts_as_mappable_hash
  validates_format_of :gps, :with => GPS_REGEX, :allow_blank => true
  
  belongs_to :creator, :class_name=>"User", :foreign_key => 'creator_user_id'

  has_many :attendances, :dependent => :destroy
  has_many :attendees, :through=>:attendances
  
  has_many :category_conferences, :dependent => :destroy
  has_many :categories, :through=>:category_conferences
  
  
  validates_presence_of :name, :start_date, :end_date, :description, :location#, :categories
  
end
