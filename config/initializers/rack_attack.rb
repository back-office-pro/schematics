# frozen_string_literal: true

module Rack
  class Attack
    throttle('req/ip', limit: 300, period: 5.minutes) do |req|
      req.ip unless req.path.start_with?('/assets')
    end

    throttle('logins/email', limit: 5, period: 20.seconds) do |req|
      if req.path == Rails.application.routes.url_helpers.sessions_path && req.post?
        req.params['session']['email'].to_s.downcase.gsub(/\s+/, '')
      end
    end

    throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
      req.ip if req.path == Rails.application.routes.url_helpers.sessions_path && req.post?
    end
  end
end
