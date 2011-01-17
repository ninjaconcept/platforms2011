require 'yaml'

module NcDataReflection
  
  class Config
    
    def self.config_file
      Rails.root.to_s + '/config/nc_data_reflection.yml'
    end
  
    def self.load_config
      begin
        YAML.load_file(config_file)
      rescue Exception
        puts ""
        puts ""
        puts "**************************************************************************************"
        puts ""
        puts "please perform 'script/generate nc_data_reflection PROJECTNAME' to create config file "
        puts ""
        puts "**************************************************************************************"
        puts ""
        puts ""
      end
    end
    
  end
end