#############################################################
#  Application
#############################################################

set :application,       "platforms"
set :deploy_to,         "/home/pf/rails/#{application}"

# this is for deploying on paltforms vm
set :database_password,                 "yRyomEfoasdfasdzqAOMbe"
set :deployment_database_password,      "oumberkyaoopjsdfas"

#############################################################
#  Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, false
set :scm_verbose, false
set :rails_env,   "staging"
set :migrate_env, "migration"

#############################################################
#  Servers
#############################################################

set :user, "pf"
set :domain, "#{staging_host}"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#  Git
#############################################################

set :scm, :git
set :branch, "master"
set :scm_user, 'git'
set :scm_passphrase, ""
set :repository, "git@github.com:ninjaconcept/platforms2011.git"
set :deploy_via, :export
#set :deploy_via, :remote_cache
#set :git_enable_submodules, 1


$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.2@platforms'      # Or whatever env you want it to run in.
set :rvm_type, :user