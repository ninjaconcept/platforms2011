
require 'rails/generators'
require 'rails/generators/named_base'

# module NcDeployment
#   module Generators
    class NcDataReflection < ::Rails::Generators::NamedBase
      
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      
      def create_
        template "nc_data_reflection.erb", "config/nc_data_reflection.yml", :collision => :ask
        copy_file "nc_data_reflection.rake", "lib/tasks/nc_data_reflection.rake", :collision => :ask
      end
      
    end
#   end
# end