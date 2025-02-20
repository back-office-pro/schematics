# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'webmock/rspec'

WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: [%r{https://cdnjs.cloudflare.com/ajax/libs/font-awesome}]
)
