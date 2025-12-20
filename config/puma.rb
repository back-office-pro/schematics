# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

threads ENV.fetch('RAILS_MAX_THREADS', 3)

port ENV.fetch('PORT', 3000)

bind ENV.fetch('SOCKET', "unix://#{Rails.root.join('tmp/sockets/puma.sock')}")

plugin :tmp_restart
plugin :solid_queue if Rails.env.development?
