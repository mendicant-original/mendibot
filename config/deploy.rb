require 'bundler/capistrano'

set :application, "mendibot"
set :repository,  "git://github.com/mendicant-original/mendibot.git"

set :scm, :git
set :deploy_to, "/var/rapp/#{application}"

set :user, "git"
set :use_sudo, false

set :deploy_via, :remote_cache

set :branch, "master"
server "173.246.46.66", :app, :web, :db, :primary => true

before 'deploy:update_code' do
  run "sudo god stop mendibot"
end

after 'deploy:update_code' do
  run "ln -nfs #{shared_path}/environment.rb #{release_path}/config/environment.rb"
end

after 'deploy' do
  run "sudo god load #{release_path}/config/mendibot.god"
  run "sudo god start mendibot"
end

after "deploy", 'deploy:cleanup'