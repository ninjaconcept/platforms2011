class Conference < ActiveRecord::Base

  acts_as_mappable :default_units => :kilometers,
                   :default_formula => :flat,
                   :distance_field_name => :distance,
                   :lat_column_name => :lat,
                   :lng_column_name => :lng

  belongs_to :creator, :class_name=>"User"
  has_and_belongs_to_many :attendees, :join_table => 'attendees', 
                          :class_name => "User", :uniq => true
end
