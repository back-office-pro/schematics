# frozen_string_literal: true

module Rack
  class Attack
    SESSIONS_PATHS = %w[/sessions /sessioni].freeze
    PASSWORD_RESETS_PATHS = %w[/passwords /mots-de-passe].freeze

    throttle('req/ip', limit: 300, period: 5.minutes) do |req|
      req.ip unless req.path.start_with?('/assets')
    end

    throttle('logins/email', limit: 5, period: 20.seconds) do |req|
      if SESSIONS_PATHS.include?(req.path) && req.post?
        req.params.dig('session', 'email')&.to_s&.downcase&.gsub(/\s+/, '')
      end
    end

    throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
      req.ip if SESSIONS_PATHS.include?(req.path) && req.post?
    end

    throttle('password_resets/ip', limit: 5, period: 1.minute) do |req|
      req.ip if PASSWORD_RESETS_PATHS.include?(req.path) && req.post?
    end
  end
end
