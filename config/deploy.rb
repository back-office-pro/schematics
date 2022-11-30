# frozen_string_literal: true

require 'tenant'

lock '~> 3.17.1'

name = ENV.fetch('APP_NAME') { raise StandardError, 'Missing APP_NAME env variable' }
tenant = ::Tenant.new(name:)

set :application, tenant.name
set :repo_url, tenant.git_remote
set :deploy_to, tenant.deploy_directory

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
