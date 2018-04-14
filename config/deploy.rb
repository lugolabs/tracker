load 'config/deploy/server.rb'

set :application,           'tracker'
set :ssl_certificate,       "/etc/letsencrypt/live/#{fetch(:ssl_domain)}/fullchain.pem"
set :ssl_key,               "/etc/letsencrypt/live/#{fetch(:ssl_domain)}/privkey.pem"
set :enable_ssl,            true

set :default_env,           { 'NODE_ENV' => 'production' }
set :format,                :pretty
set :log_level,             :debug
set :pty,                   true
set :full_app_name,         "#{fetch(:application)}_#{fetch(:stage)}"
set :deploy_to,             "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"
set :use_sudo,              false

set :linked_files,          %w(config/database.yml config/application.yml config/sidekiq.yml)
set :linked_dirs,           %w(log tmp/pids tmp/cache tmp/sockets tmp/downloads public/uploads vendor/bundle public/packs node_modules)

set :rbenv_type,            :system
set :rbenv_ruby,            '2.5.0'
set :rbenv_custom_path,     "/home/#{fetch(:deploy_user)}/.rbenv"
set :rbenv_prefix,          "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"

set :repo_url,              'git@github.com:lugolabs/tracker.git'
set :branch,                'master'
set :keep_releases,         3
set :keep_assets,           1
set :sidekiq_pid_path,      "#{current_path}/tmp/pids/sidekiq"
set :sidekiq_pid,           "#{fetch(:sidekiq_pid_path)}.pid"
set :sidekiq_concurrency,   8

set :tests,                   []
set :assets_roles,            [:app]
set :config_files,            %w(nginx.conf monit sidekiq_init.sh)
set :executable_config_files, %w(sidekiq_init.sh)
set(:symlinks, [
  {
    source: 'nginx.conf',
    link:   '/etc/nginx/sites-enabled/{{full_app_name}}'
  },
  {
    source: 'log_rotation',
    link:   '/etc/logrotate.d/{{full_app_name}}'
  },
  {
    source: 'sidekiq.yml',
    link:   "#{current_path}/config/sidekiq.yml"
  },
  {
    source: 'sidekiq_init.sh',
    link:   '/etc/init.d/sidekiq_{{full_app_name}}'
  },
  {
    source: 'monit',
    link:   '/etc/monit/conf.d/{{full_app_name}}.conf'
  }
])

set :puma_bind,               "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,              "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,                "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log,         "#{shared_path}/log/puma.error.log"
set :puma_error_log,          "#{shared_path}/log/puma.access.log"
set :puma_preload_app,        true
set :puma_worker_timeout,     nil
set :puma_init_active_record, true

namespace :deploy do
  desc 'Clear cache'
  task :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, 'RAILS_ENV=production tmp:clear'
      end
    end
  end

  desc 'Update crontab with whenever'
  task :update_crontab do
    on roles(:all) do
      within release_path do
        execute :bundle, :exec, "whenever --update-crontab #{fetch(:application)}"
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      if (site_url = fetch(:website_url))
        execute :curl, site_url
      end
    end
  end

  before :deploy, 'deploy:check_revision'
  # before :deploy, 'deploy:run_tests'

  after 'deploy:symlink:shared', 'deploy:compile_packs_locally'

  after :finishing, :cleanup
  after :finishing, :restart

  after 'deploy:setup_config', 'nginx:reload'
  after 'deploy:setup_config', 'monit:restart'
end
