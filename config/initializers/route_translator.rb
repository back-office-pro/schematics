# frozen_string_literal: true

RouteTranslator.config do |config|
  config.hide_locale = !Rails.env.test?
end
