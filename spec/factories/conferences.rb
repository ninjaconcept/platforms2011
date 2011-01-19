# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :conference do |f|
  f.sequence(:name) {|n| "conference #{n}" }
  f.creator { Factory(:user) }
  f.series_id 1
  f.start_date "2011-01-18"
  f.end_date "2011-01-18"
  f.description "MyString"
  f.location "MyString"
  f.venue "MyString"
  f.accomodation "MyString"
  f.howtofind "MyString"
  f.categories { [Factory(:category)] }
end

Factory.define :new_conference, :class => Conference do |f|
  f.name "FunConf"
  f.creator_user_id 1
  f.series_id 1
  f.start_date "2011-01-18"
  f.end_date "2011-01-18"
  f.description "MyString"
  f.location "MyString"
  f.venue "MyString"
  f.accomodation "MyString"
  f.howtofind "MyString"
  f.categories { [Factory(:category)] }
end