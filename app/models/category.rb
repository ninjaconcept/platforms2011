class Category < ActiveRecord::Base

  has_ancestry :cache_depth => true #, :orphan_strategy => :restrict
  has_friendly_id :name, :use_slug => true, :approximate_ascii => true  
    
  has_many :conferences
  
  validates_presence_of :name
  
  include Pacecar
end
