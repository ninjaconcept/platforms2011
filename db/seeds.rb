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

FactoryDefaults.import

Conference.first.attendees = User.all(:limit => 5)
