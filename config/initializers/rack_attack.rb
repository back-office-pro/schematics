# frozen_string_literal: true

Rack::Attack.safelist_ip('127.0.0.1')
Rack::Attack.safelist_ip('::1')
Rack::Attack.throttle('requests by ip', limit: 5, period: 2, &:ip)
