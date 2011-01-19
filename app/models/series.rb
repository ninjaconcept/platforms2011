#origin GM

# This class abstracts series from the database

class Series < ActiveRecord::Base
  
  validates_uniqueness_of :name
  validates_presence_of :name
  
  has_and_belongs_to_many :contacts, :class_name => 'User', :join_table => :series_contacts
  
  has_many :conferences
  # has_and_belongs_to_many :series_contacts, :dependent => :destroy
  # has_many :contacts, :through => :series_contacts, :source => :user
  
  def version
    #lock_version
  end
  
  def version=(arg)
    #self.lock_version = arg
  end
   
  def to_json(opts = {})
    super(
      :only => [:version, :id, :name],
      :include => {:contacts => {:only => :username}}
    )
  end
end
