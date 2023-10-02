# frozen_string_literal: true

module Rack
  class Attack
    class << self
      def password_resets_paths = ::I18n
        .available_locales
        .map { ::Schematics::Engine.routes.url_helpers.public_send(:"password_resets_#{_1}_path") }
        .uniq

      def sessions_paths = ::I18n
        .available_locales
        .map { ::Rails.application.routes.url_helpers.public_send(:"sessions_#{_1}_path") }
        .uniq
    end

    throttle('req/ip', limit: 300, period: 5.minutes) do |req|
      req.ip unless req.path.start_with?('/assets')
    end

    throttle('logins/email', limit: 5, period: 20.seconds) do |req|
      if sessions_paths.include?(req.path) && req.post?
        req.params['session']['email'].to_s.downcase.gsub(/\s+/, '')
      end
    end

    throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
      req.ip if sessions_paths.include?(req.path) && req.post?
    end

    throttle('password_resets/ip', limit: 5, period: 1.minute) do |req|
      req.ip if password_resets_paths.include?(req.path) && req.post?
    end
  end
end
