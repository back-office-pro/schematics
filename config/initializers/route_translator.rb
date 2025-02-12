# frozen_string_literal: true

RouteTranslator.config do |config|
  i18n = Rails.configuration.i18n
  config.available_locales = i18n.available_locales
  config.hide_locale = !Rails.env.test?
end
