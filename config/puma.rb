# frozen_string_literal: true

threads ENV.fetch('RAILS_MAX_THREADS', 3)

port ENV.fetch('PORT', Tenant.port) if Rails.env.development?

bind ENV.fetch('SOCKET', "unix://#{Rails.root.join('tmp/sockets/puma.sock')}")

pidfile ENV['PIDFILE'] if ENV['PIDFILE']

plugin :tmp_restart
plugin :solid_queue
