Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

Rack::Attack.safelist('allow from localhost') do |req|
  '127.0.0.1' == req.ip || '::1' == req.ip
end

Rack::Attack.throttle("requests by ip", limit: 5, period: 2) do |request|
  request.ip
end

ActiveSupport::Notifications.subscribe("throttle.rack_attack") do |_, _, _, _, payload|
  Rails.logger.info "Throttled IP: #{payload[:request].ip}"
end
