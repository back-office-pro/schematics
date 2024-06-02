# frozen_string_literal: true

threads_count = ENV.fetch('RAILS_MAX_THREADS', 7)
threads threads_count, threads_count

rails_env = ENV.fetch('RAILS_ENV', 'development')
environment rails_env

case rails_env
when 'production'
  require 'concurrent-ruby'
  workers_count = Integer(ENV.fetch('WEB_CONCURRENCY', Concurrent.available_processor_count))
  workers workers_count if workers_count > 1
when 'development'
  worker_timeout 3600
  port ENV.fetch('PORT', Tenant::DEFAULT_PORT)
end

bind ENV.fetch('SOCKET', "unix://#{Rails.root.join('tmp/sockets/puma.sock')}")

pidfile ENV.fetch('PIDFILE', 'tmp/pids/server.pid')

preload_app!

plugin :tmp_restart
plugin :solid_queue

Tenant.search_engine.initialize!
