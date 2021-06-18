# frozen_string_literal: true

module Schematics
  module Localizable
    extend ActiveSupport::Concern

    def current_locale
      current_user&.locale&.downcase ||
        I18n.available_locales.include?(http_header_locale) && http_header_locale ||
        I18n.default_locale
    end

    def switch_locale(&action)
      I18n.with_locale(current_locale, &action)
    end

    def switch_beginning_of_week(&action)
      I18n.in_beginning_of_week(&action)
    end

    def switch_time_zone(&action)
      Time.use_zone(current_user.time_zone, &action)
    end

    private

    def http_header_locale
      request
        .env['HTTP_ACCEPT_LANGUAGE']
        &.scan(/^[a-z]{2}/)
        &.to_a
        &.first
        &.to_sym
    end
  end
end
