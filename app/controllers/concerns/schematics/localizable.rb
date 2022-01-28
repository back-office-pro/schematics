# frozen_string_literal: true

module Schematics
  module Localizable
    extend ActiveSupport::Concern

    included do
      around_action :switch_locale
      around_action :switch_beginning_of_week
      around_action :switch_time_zone
    end

    def switch_locale(&)
      I18n.with_locale(current_user&.locale || http_header_locale, &) rescue yield
    end

    def switch_beginning_of_week(&)
      I18n.in_beginning_of_week(&)
    end

    def switch_time_zone(&)
      Time.use_zone(current_user&.time_zone, &) rescue yield
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
