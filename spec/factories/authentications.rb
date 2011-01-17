# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :authentication do |f|
  f.user_id 1
  f.provider "MyString"
  f.uid "MyString"
end
