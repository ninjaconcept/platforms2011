source 'http://rubygems.org'

gem 'rails', '3.0.3'

gem 'devise'

gem 'haml'
gem 'compass'
gem 'passenger'
gem 'inherited_resources', '1.1.2'
gem 'friendly_id'
gem 'simple_form'
gem 'ancestry'
gem 'pacecar'
gem 'omniauth'
gem 'jquery-rails'
gem 'git'

gem 'basiszwo-reflection'
gem 'hoptoad_notifier'

group :production, :migration do
  gem 'mysql' # mysql2 does not work on alpha5
end

group :development do
  gem 'rails3-generators'
  gem 'haml-rails'
  
  gem 'capistrano'
  gem 'capistrano-ext'
  
  gem 'mysql2' # mysql2 does not work on alpha5
end

group :test, :cucumber, :development do  
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'shoulda'
  gem 'rspec-rails'
  gem 'spork'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'pickle'
  gem 'ZenTest'
  
end