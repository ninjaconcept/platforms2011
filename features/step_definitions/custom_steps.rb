Given /^I am logged in with "([^"]*)\/([^"]*)"$/ do |username, password|
  And %{I am on "/users/sign_in"}
  And %{I fill in "user_username" with "#{username}"}
  And %{I fill in "user_password" with "#{password}"}
  And %{I press "Sign in"}
end

Given /^I am logged out/ do
  And %{I follow "Logout"}
end

Then /^I should see the following table at "([^"]*)":$/ do |selector, expected_table|
  expected_table.diff!(tableish("table#{selector} tr", 'th,td'))
end

Given /^no category records exist$/ do
  (0..Category.maximum(:ancestry_depth)).each do |depth|
    Category.destroy_all(:ancestry_depth => depth)
  end
end

Given /^no conference records exist$/ do
  Series.all.each do |series|
    series.contacts.destroy_all
  end
  
  Series.destroy_all
  Conference.destroy_all
  
  # Conference.all.each do |conf|
  #   conf.series.contacts.destroy_all if conf.series
  #   conf.series.destroy
  #   conf.destroy
  # end
end

Given /^no ([^"]*) exists$/ do |model|
  model.classify.constantize.all.each { |entry| entry.destroy }  
  model.classify.constantize.all.length.should == 0
end

Then /^I should get a download with the filename "([^\"]*)"$/ do |filename|
  page.response_headers['Content-Disposition'].should include("filename=\"#{filename}\"")
end

# create models from a table
Given(/^the following (document)s? and their files? exists?:?$/) do |plural_factory, table|
  table.hashes.each{ |row| 
    directory = File.dirname(row[:filename])
    `mkdir -p #{directory}`; `touch #{row[:filename]}` }
  create_models_from_table(plural_factory, table)
 
end