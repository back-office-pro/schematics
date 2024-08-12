# frozen_string_literal: true

threads_count = ENV.fetch('RAILS_MAX_THREADS', 7)
threads threads_count, threads_count

port ENV.fetch('PORT', Tenant.port) if Rails.env.development?

bind ENV.fetch('SOCKET', "unix://#{Rails.root.join('tmp/sockets/puma.sock')}")

pidfile ENV['PIDFILE'] if ENV['PIDFILE']

plugin :tmp_restart
plugin :solid_queue

solid_queue_mode Tenant.search_engine.backend_mode

Tenant.search_engine.initialize!
