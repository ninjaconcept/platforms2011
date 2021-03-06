require 'rails/generators'
require 'rails/generators/named_base'

class NcDeploymentGenerator < ::Rails::Generators::NamedBase
  
  source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
  
  
  def create_
    copy_file "Capfile", "Capfile", :collision => :ask
    template "environments/staging.rb", "config/environments/staging.rb", :collision => :ask
    template "environments/migration.rb", "config/environments/migration.rb", :collision => :ask

    copy_file "deploy.rb", "config/deploy.rb", :collision => :ask
    copy_file "deploy/config.rb.example", "config/deploy/config.rb.example", :collision => :ask
    template "deploy/production.erb", "config/deploy/production.rb", :collision => :ask
    template "deploy/staging.erb", "config/deploy/staging.rb", :collision => :ask
    
    copy_file "lib/tasks/nc_deployment.rake", "lib/tasks/nc_deployment.rake", :collision => :ask
    copy_file "lib/tasks/nc_sass.rake", "lib/tasks/nc_sass.rake", :collision => :ask
  end
  
end