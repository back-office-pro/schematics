# frozen_string_literal: true

max_threads_count = ENV.fetch('RAILS_MAX_THREADS', 10)
min_threads_count = ENV.fetch('RAILS_MIN_THREADS') { max_threads_count }
threads min_threads_count, max_threads_count

if ENV.fetch('RAILS_ENV', 'development') == 'development'
  worker_timeout 3600
  port Tenant::DEFAULT_PORT
end

environment ENV.fetch('RAILS_ENV', 'development')

bind ENV.fetch('SOCKET', "unix://#{Rails.root.join('tmp/sockets/puma.sock')}")

pidfile ENV.fetch('PIDFILE', 'tmp/pids/server.pid')

workers ENV.fetch('WEB_CONCURRENCY', Tenant.backend.concurrency)

preload_app!

plugin :tmp_restart

case Tenant.backend
when Backend::Redis
  x = nil
  on_worker_boot do
    x = Sidekiq.configure_embed {} # rubocop:disable Lint/EmptyBlock
    x.run
  end
  on_worker_shutdown { x&.stop }
end

Tenant.search_engine.initialize!
