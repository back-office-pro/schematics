# frozen_string_literal: true

lock '~> 3.17.1'

app_name = File.basename(Dir.getwd)

set :application, app_name
set :repo_url, "git@github.com:back-office-pro/#{app_name}.git"
set :deploy_to, "/home/deploy/#{app_name}"
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
