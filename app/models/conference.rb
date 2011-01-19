class Conference < ActiveRecord::Base
  @@per_page = 10 #for will_paginate  

  include GeoHelper
  class << self
    include GeoHelper
  end
  
  attr_accessor :just_created, :search_term

  has_friendly_id :name, :use_slug => true, :approximate_ascii => true
  
  acts_as_mappable acts_as_mappable_hash
  validates_format_of :gps, :with => GPS_REGEX, :allow_blank => true
  
  belongs_to :creator, :class_name=>"User", :foreign_key => 'creator_user_id'
  belongs_to :series

  belongs_to :series, :dependent => :destroy

  has_many :attendances, :dependent => :destroy
  has_many :attendees, :through => :attendances, :source => :user
  
  has_many :category_conferences, :dependent => :destroy
  has_many :categories, :through=>:category_conferences
  
  validates_presence_of :name, :start_date, :end_date, :description, :location
  validates_presence_of :categories, :unless => :just_created
  
  def version
    lock_version
  end
  
  def version=(arg)
    self.lock_version = arg
  end
  
  
  def to_json(opts = nil)
    if opts
      super
    else
      super( 
        :only => [:version, :id, :name, :startdate, :enddate, :description, :location, :gps, :venue, :accomodation, :howtofind],
        :include => {:creator => {:only => :username}, :categories => {:only => :name}}
      )
    end
  end

end
