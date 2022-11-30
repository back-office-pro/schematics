# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

lock '~> 3.17.1'

app_name = ENV.fetch('APP_NAME') { raise StandardError, 'Missing APP_NAME env variable' }
subdomain = app_name.dasherize

set :application, app_name
set :repo_url, "git@github.com:back-office-pro/#{subdomain}.git"
set :deploy_to, "/home/deploy/#{subdomain}"

append :linked_files, 'config/database.yml', 'config/secrets.yml'
append :linked_dirs,
       'log',
       'tmp/pids',
       'tmp/cache',
       'tmp/sockets',
       'vendor/bundle',
       'public/system',
       'public/uploads',
       '.bundle'
