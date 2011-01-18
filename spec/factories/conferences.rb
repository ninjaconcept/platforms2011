# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :conference do |f|
  f.name "MyString"
  f.creator_user_id 1
  f.series_id 1
  f.start_date "2011-01-18"
  f.end_date "2011-01-18"
  f.description "MyString"
  f.location "MyString"
  f.gps_long 1.5
  f.gps_lat 1.5
  f.venue "MyString"
  f.accomodation "MyString"
  f.howtofind "MyString"
end

Factory.define :new_conference, :class => Conference do |f|
  f.name "FunConf"
  f.creator_user_id 1
  f.series_id 1
  f.start_date "2011-01-18"
  f.end_date "2011-01-18"
  f.description "MyString"
  f.location "MyString"
  f.gps_long 1.5
  f.gps_lat 1.5
  f.venue "MyString"
  f.accomodation "MyString"
  f.howtofind "MyString"
end