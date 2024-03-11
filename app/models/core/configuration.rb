# frozen_string_literal: true

class Configuration < Schematics::ApplicationRecord
  LOCALE_TO_TIME_ZONE = { en: 'UTC', fr: 'Paris', it: 'Rome' }.freeze

  attribute :company_name, default: -> { Tenant.human }
  attribute :available_locales, default: -> { Rails.configuration.i18n.available_locales.map(&:to_s) } # rubocop:disable Layout/LineLength
  attribute :locale, default: -> { Rails.configuration.i18n.default_locale }

  def time_zone
    super || LOCALE_TO_TIME_ZONE[locale&.to_sym]
  end
end
