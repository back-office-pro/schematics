# frozen_string_literal: true

RouteTranslator.config do |config|
  config.available_locales = Rails.configuration.i18n.available_locales
  config.hide_locale = !Rails.env.test?
end
