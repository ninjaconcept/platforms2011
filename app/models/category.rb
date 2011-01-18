class Category < ActiveRecord::Base

  has_ancestry :cache_depth => true, :orphan_strategy => :destroy
  has_friendly_id :name, :use_slug => true, :approximate_ascii => true  
    
  has_many :category_conferences, :dependent => :destroy
  has_many :conferences, :through => :category_conferences
  
  validates_presence_of :name
  
  include Pacecar
end
