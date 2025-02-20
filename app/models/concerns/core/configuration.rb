# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
module Core
  module Configuration
    extend ActiveSupport::Concern

    LOCALE_TO_TIME_ZONE = { en: 'UTC', fr: 'Paris', it: 'Rome' }.freeze

    prepended do
      attribute :available_locales, default: -> { Rails.configuration.i18n.available_locales.map(&:to_s) } # rubocop:disable Layout/LineLength
      attribute :locale, default: -> { Rails.configuration.i18n.default_locale }

      after_update_commit :clear_bootstrap_email_sass_cache!
      after_update_commit :update_storage_services!
    end

    class_methods do
      def time_zone_with_fallback
        time_zone || LOCALE_TO_TIME_ZONE[locale&.to_sym]
      end

      def openai_access_token_with_fallback
        openai_access_token || Schematics::Engine.credentials.openai&.access_token
      end

      def gcloud_api_key_with_fallback
        gcloud_api_key || Schematics::Engine.credentials.gcloud&.api_key
      end
    end

    def update_storage_services! # rubocop:disable Obsession/Rails/PrivateCallback
      ActiveStorage::Blob.services = ActiveStorage::Service::Registry.new(storage_configurations)
      ActiveStorage::Blob.service = ActiveStorage::Blob.services.fetch(storage_service)
    end

    private

    def clear_bootstrap_email_sass_cache!
      BootstrapEmail.clear_sass_cache! if theme_color_previously_changed?
    end

    def storage_configurations = Schematics::Engine # rubocop:disable Metrics/CyclomaticComplexity
      .config_for(:storage)
      .tap do |config|
        config[:amazon][:access_key_id] = aws_access_key_id if aws_access_key_id
        config[:amazon][:secret_access_key] = aws_secret_access_key if aws_secret_access_key
        config[:amazon][:region] = aws_region if aws_region
        config[:microsoft][:storage_account_name] = azure_storage_account_name if azure_storage_account_name # rubocop:disable Layout/LineLength
        config[:microsoft][:storage_access_key] = azure_storage_access_key if azure_storage_access_key # rubocop:disable Layout/LineLength
        config[:google][:credentials][:private_key_id] = gcs_private_key_id if gcs_private_key_id
        config[:google][:credentials][:private_key] = gcs_private_key if gcs_private_key
      end

    def storage_service # rubocop:disable Metrics/CyclomaticComplexity
      return :amazon if aws_access_key_id && aws_secret_access_key && aws_region
      return :microsoft if azure_storage_account_name && azure_storage_access_key
      return :google if gcs_private_key_id && gcs_private_key

      Rails.configuration.active_storage.service
    end
  end
end
