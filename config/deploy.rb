# config valid only for current version of Capistrano
lock "3.8.0"

set :application, "horror_parser"
set :repo_url, "https://github.com/d4rk5eed/horror_parser.git"

# Default branch is :master
ask :branch, 'v2.0-stable'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/ec2-user/horror_parser"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/config.yml"

# Default value for linked_dirs is []
append :linked_dirs, "config", "log", "tmp/pids", "tmp/cache", "tmp/sockets"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5
set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.3.3'
