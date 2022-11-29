# frozen_string_literal: true

Rails.configuration.to_prepare do
  Rails.configuration.i18n.default_locale = ::Configuration.instance.locale.to_sym
  Rails.configuration.time_zone = ::Configuration.instance.time_zone
rescue StandardError
  # do nothing
end
