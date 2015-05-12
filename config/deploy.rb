# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'bpm'
set :deploy_user, 'mike'


set :scm, :git
set :repo_url, 'git@github.com:klishevich/bpm.git'
set :assets_roles, [:app]
set :keep_releases, 5
set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :tests, []
set(:config_files, %w(
  database.yml
  unicorn_init.sh
  secrets.yml
))
set(:executable_config_files, %w(
  unicorn_init.sh
))
set(:symlinks, [
  {
    # source: "/home/mike/apps/{{full_app_name}}/shared/config/unicorn_init.sh",
    # link: "/etc/init.d/unicorn_{{full_app_name}}"
  }
])

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
	    before :deploy, "deploy:check_revision"
	    after :finishing, 'deploy:cleanup'
  	  after 'deploy:setup_config', 'nginx:reload'
      after 'deploy:publishing', 'deploy:restart'
      desc 'Restart application'
      task :restart do
        invoke 'unicorn:restart2'
      end 
    end
  end

end

namespace :unicorn do

  desc 'Restart unicorn 2'
  task :restart2 do
    on roles(:web) do
      execute "/etc/init.d/unicorn_bpm_production restart"
    end
  end  

end
