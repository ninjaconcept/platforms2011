#origin: M
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


=begin
drop the complete db manually:
drop table attendies;
drop table authentications;
drop table category_conferences;
drop table categories;
drop table conferences;
drop table rcd_statuses;
drop table schema_migrations;
drop table series;
drop table slugs;
drop table users;
=end

require 'json'

json = File.new("#{Rails.root}/db/data.json", 'r').read
array=JSON::parse(json)
users=array[0]
categories=array[1]
member_of_series=array[2]
conferences=array[3]

u_hash=users[0] #for manual testing...
users.each do |u_hash|
  #adjust hash, so we can use it directly
  u_hash["password_confirmation"]=u_hash["password"]
  u_hash["email"]=u_hash["email"].strip #error in json data
  puts "creating user #{u_hash["username"]}"
  gps=u_hash.delete "gps"
  if gps
    gps.gsub("O","E") #change "O"st to "E"ast if applicable
    User::GPS_REGEX=~gps
    u_hash["lat"]=$1
    u_hash["lat"]=-u_hash["lat"].to_f if ["s","S"].include? $3
    u_hash["lng"]=$4
    u_hash["lng"]=-u_hash["lng"].to_f if ["w","W"].include? $6
  end
  User.create!(u_hash) #this works, since username etc. is also attr_accessible...
end

categories.each do |c_hash|
  parent_name=c_hash["parent"]["name"] if c_hash["parent"]
  if parent_name
    parent_cat=Category.find_by_name(parent_name)
    if parent_cat.nil?
      parent_cat=Category.create!(:name=>parent_name) #if not found, create it
    end
    c_hash["parent"] = parent_cat
  end
  c_hash.delete "subcategories" #should be redundant to parent
  c_hash.delete "parent" #
  puts "creating/updating category #{c_hash["name"]}"
  cat=Category.find_by_name(c_hash["name"])
  if cat
    cat.update_attributes(c_hash)
  else
    Category.new(c_hash)
  end
end

member_of_series.each do |ms_hash|
  series=Series.create!(:name=>ms_hash["name"])
  username=ms_hash["contacts"][0]["username"] #simple enough here, because testdata always follows this scheme
  MemberOfSeries.create!(:series_id=>series.id, :user_id=>User.find_by_username(username).id)
end

conf_hash=conferences[13]
conferences.each do |conf_hash|
  conf_hash["creator"]=User.find_by_username(conf_hash["creator"]["username"]) #creater attrbiute has another semantiv now: it's a Rails Model
  #conf_hash.delete "creator"
  conf_hash["series"]=Series.find_by_name(conf_hash["series"]["name"]) if conf_hash["series"] and conf_hash["series"]["name"] #may be empty
  conf_hash.delete "series"
  conf_hash["start_date"]=Date.parse(conf_hash["startdate"]) #luckily Rails swallows this input format: 20091227
  conf_hash.delete "startdate"
  conf_hash["end_date"]=Date.parse(conf_hash["enddate"]) #dito
  conf_hash.delete "enddate"
  categories_array=conf_hash.delete "categories"
  conf_hash.delete "gps" # TODO
  puts "creating conference #{conf_hash["name"]}"
  conf=Conference.create!(conf_hash)
  categories_array.map do |cat_hash|
    cat=Category.find_by_name(cat_hash["name"])
    CategoryConference.create!(:conference=>conf, :category=>cat)
  end
  #conf_hash.delete "categories"
end