namespace :nc do
  namespace :reflection do
  
    desc "stash the current database and assets"
    task :stash => :environment do
      config = NcDataReflection::Config.load_config
      
      system("rm -rf ~/.reflection")
    
      command = "reflection --stash --directory #{Rails.root.to_s}/public/#{config[:asset_directory]} --repository #{config[:git_repository]} --rails #{Rails.root.to_s} --rails-env #{Rails.env} -v"
      system(command)  
    end
  
    desc "apply previously stashed database and assets"
    task :apply => :environment do
      config = NcDataReflection::Config.load_config
      
      command = "reflection --apply --directory #{Rails.root.to_s}/public/#{config[:asset_directory]} --repository #{config[:git_repository]} --rails #{Rails.root.to_s} --rails-env #{Rails.env} --force -v"
      system(command)
    end
  
  end
end