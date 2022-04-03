# frozen_string_literal: true

Rack::Attack.safelist('127.0.0.1')
Rack::Attack.safelist('::1')
Rack::Attack.throttle('requests by ip', limit: 5, period: 2, &:ip)
