# frozen_string_literal: true

Rack::Attack.safelist_ip('127.0.0.1')
Rack::Attack.safelist_ip('::1')
Rack::Attack.throttle('requests by ip', limit: 5, period: 2, &:ip)
Rack::Attack.throttle('limit logins per email', limit: 6, period: 60) do |req|
  req.params['session']['email'].to_s.downcase.gsub(/\s+/, '') if req.path == '/login' && req.post?
end
