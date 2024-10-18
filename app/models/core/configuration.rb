# frozen_string_literal: true

class Configuration < Schematics::ApplicationRecord
  attribute :company_name, default: -> { Tenant.human }
  attribute :available_locales, default: -> { Rails.configuration.i18n.available_locales.map(&:to_s) } # rubocop:disable Layout/LineLength
  attribute :locale, default: -> { Rails.configuration.i18n.default_locale }

  class << self
    LOCALE_TO_TIME_ZONE = { en: 'UTC', fr: 'Paris', it: 'Rome' }.freeze

    def time_zone_with_fallback
      time_zone || LOCALE_TO_TIME_ZONE[locale&.to_sym]
    end

    def openai_access_token_with_fallback
      openai_access_token || Schematics::Engine.credentials.openai.access_token
    end

    def gcloud_api_key_with_fallback
      gcloud_api_key || Schematics::Engine.credentials.gcloud.api_key
    end
  end
end
