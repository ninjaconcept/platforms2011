# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :category do |f|
  f.sequence(:name) {|n| "category #{n}" }
end
