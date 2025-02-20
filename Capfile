# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

set :deploy_config_path, File.expand_path('config/deploy.rb', __dir__)
set :stage_config_path, File.expand_path('config/deploy', __dir__)

require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/puma'
require 'capistrano/scm/git'

install_plugin Capistrano::SCM::Git
install_plugin Capistrano::Puma
