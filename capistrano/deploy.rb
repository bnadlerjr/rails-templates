# Steps for a cold deploy:
#   cap deploy:setup
#   cap deploy:check
#   cap deploy:update
#   cap deploy:migrate
#   cap db:seed
#   cap deploy:restart

set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

# TODO: Specify app name
set :application, "my_app"

set :scm, :git

# TODO: Specify path to git repo
set :repository, "path/to/repo/#{application}.git"
set :branch, "master"
set :scm_verbose, true

set :deploy_via, :copy
set :copy_cache, "/tmp/deploy-cache/#{application}"
set :copy_exclude, [".git/*"]

set :use_sudo, false

namespace :deploy do
  desc 'Does nothing, run individual tasks instead.'
  task :cold do ; end
  
  desc 'Does nothing, not needed when using Passenger.'
  task :start do ; end
  
  desc 'Does nothing, not needed when using Passenger.'
  task :stop do ; end
  
  desc 'Restarts Passenger.'
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  desc 'Sets up vhost file.'
  task :vhost, :roles => :web, :except => { :no_release => true } do
    vhost = ERB.new(vhost_template)
    put vhost.result(binding), "/home/#{user}/#{application}"
    run "#{sudo} mv ~/#{application} /etc/apache2/sites-available/"
    run "#{sudo} a2ensite #{application}"
    run "#{sudo} a2enmod rewrite"
    run "#{sudo} /etc/init.d/apache2 reload"
  end
  
  desc 'Builds any native extensions for gems'
  task :build_gems, :except => { :no_release => true } do
    run "cd #{deploy_to}/current && rake RAILS_ENV=#{rails_env} gems:refresh_specs"
    run "cd #{deploy_to}/current && rake RAILS_ENV=#{rails_env} gems:build"    
  end
end

namespace :db do
  desc 'Creates database.yml in shared path.'
  task :setup, :except => { :no_release => true } do
    template = <<-EOF
    base: &base
      adapter: sqlite3
      timeout: 5000
    development:
      database: #{shared_path}/db/development.sqlite3
      <<: *base
    test:
      database: #{shared_path}/db/test.sqlite3
      <<: *base
    staging:
      database: #{shared_path}/db/stage.sqlite3
      <<: *base
    production:
      database: #{shared_path}/db/production.sqlite3
      <<: *base
    EOF
    
    config = ERB.new(template)
    run "mkdir -p #{shared_path}/db"
    run "mkdir -p #{shared_path}/config"
    put config.result(binding), "#{shared_path}/config/database.yml"
  end
  
  desc 'Symlink the shared database.yml file.'
  task :symlink, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  
  desc 'Load seed data.'
  task :seed, :except => { :no_release => true } do
    run "cd #{deploy_to}/current && rake RAILS_ENV=#{rails_env} db:seed"
  end
end

after "deploy:setup", "deploy:vhost"
after "deploy:setup", "db:setup"

after "deploy:finalize_update", "db:symlink"
after "deploy:symlink", "deploy:build_gems"
