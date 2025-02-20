# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

lock '3.18.0'

app_name = File.basename(Dir.getwd)

set :application, app_name
set :repo_url, "git@github.com:back-office-pro/#{app_name}.git"
set :deploy_to, "/home/deploy/#{app_name}"
set :bundle_config, { deployment: false }
set :default_env, { CI: true, BUNDLE_GITHUB__COM: "x-access-token:#{ENV['BUNDLE_GITHUB__COM']}" } # rubocop:disable Style/FetchEnvVar
set :branch, 'main'

append :linked_dirs,
       'log',
       'tmp/pids',
       'tmp/cache',
       'tmp/sockets',
       'vendor/bundle',
       'public/system',
       'public/uploads',
       '.bundle'
