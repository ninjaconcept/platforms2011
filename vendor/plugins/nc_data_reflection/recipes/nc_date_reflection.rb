namespace :nc do
  namespace :reflection do
    desc "stash the current database and assets"
    task :stash do
      run "cd #{current_path}; rake RAILS_ENV=#{migrate_env} nc:reflection:stash"
    end
  
    desc "apply previously stashed database and assets"
    task :apply do
      run "cd #{current_path}; rake RAILS_ENV=#{migrate_env} nc:reflection:apply"
    end
  end
end