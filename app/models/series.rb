class Series < ActiveRecord::Base
  
  validates_uniqueness_of :name
  validates_presence_of :name
  
  has_and_belongs_to_many :contacts, :class_name => 'User', :join_table => :series_contacts
  
  # has_and_belongs_to_many :series_contacts, :dependent => :destroy
  # has_many :contacts, :through => :series_contacts, :source => :user
  
end
