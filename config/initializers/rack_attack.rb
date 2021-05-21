# frozen_string_literal: true

Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

Rack::Attack.safelist('allow from localhost') do |req|
  req.ip == '127.0.0.1' || req.ip == '::1'
end

Rack::Attack.throttle('requests by ip', limit: 5, period: 2, &:ip)

ActiveSupport::Notifications
  .subscribe('throttle.rack_attack') do |_name, _start, _finish, _request_id, payload|
  Rails.logger.info "Throttled IP: #{payload[:request].ip}"
end
