# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

threads ENV.fetch('RAILS_MAX_THREADS', 3)

port ENV.fetch('PORT', ::Server::DEFAULT_PORT) if Rails.env.development? # rubocop:disable Style/RedundantConstantBase

pidfile ENV.fetch('PIDFILE', Rails.root.join("tmp/pids/#{Tenant.database_name}.pid"))

plugin :solid_queue
