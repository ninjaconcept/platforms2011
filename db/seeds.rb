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
drop table attendances;
drop table authentications;
drop table category_conferences;
drop table categories;
drop table conferences;
drop table series;
drop table rcd_statuses;
drop table schema_migrations;
drop table slugs;
drop table users;
=end

FactoryDefaults.import

User.all(:limit=>5).each do |u|
  Conference.first.attendances.create!(:user=>u)
end

[
  %w{bgates sjobs},
  %w{bgates sballmer},
  %w{sballmer bgates}
].each do |users|
  RcdStatus.send_rcd(User.find_by_username(users[0]),User.find_by_username(users[1]))
end
