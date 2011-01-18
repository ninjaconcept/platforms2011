# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :category do |f|
  f.version "MyString"
  f.name "MyString"
  f.parent_id 1
end
