# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

threads ENV.fetch('RAILS_MAX_THREADS', 3)

port ENV.fetch('PORT', ::Server::DEFAULT_PORT) # rubocop:disable Style/RedundantConstantBase

plugin :solid_queue if Rails.env.development?
