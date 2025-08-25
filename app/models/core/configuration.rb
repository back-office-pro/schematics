# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
class ::Configuration < Schematics::ApplicationRecord
  attribute :available_locales, default: -> { Rails.configuration.i18n.available_locales.map(&:to_s) } # rubocop:disable Layout/LineLength
  attribute :locale, default: -> { Rails.configuration.i18n.default_locale }

  after_update_commit :clear_bootstrap_email_sass_cache!
  after_update_commit :update_storage_services!

  class << self
    LOCALE_TO_TIME_ZONE = { en: 'UTC', fr: 'Paris', it: 'Rome' }.freeze

    def time_zone_with_fallback
      time_zone || LOCALE_TO_TIME_ZONE[locale&.to_sym]
    end

    def gcloud_public_api_key_with_fallback
      gcloud_public_api_key || Rails.application.credentials.gcloud&.public_api_key
    end

    def host
      URI(company_website.to_s).host || 'localhost'
    end

    def default_url_options
      { host:, port: }.compact
    end

    def allowed_sources = origins
      .push(company_website)
      .compact

    private

    def port
      3000 if Rails.env.development?
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

  def storage_configurations = ActiveSupport::ConfigurationFile # rubocop:disable Metrics/CyclomaticComplexity
    .parse(Rails.root.join('config/storage.yml'), symbolize_names: true)
    .tap do |config|
      config[:amazon][:bucket] = aws_bucket if aws_bucket
      config[:amazon][:access_key_id] = aws_access_key_id if aws_access_key_id
      config[:amazon][:secret_access_key] = aws_secret_access_key if aws_secret_access_key
      config[:amazon][:region] = aws_region if aws_region
      config[:microsoft][:storage_account_name] = azure_storage_account_name if azure_storage_account_name # rubocop:disable Layout/LineLength
      config[:microsoft][:storage_access_key] = azure_storage_access_key if azure_storage_access_key
      config[:google][:credentials][:private_key_id] = gcs_private_key_id if gcs_private_key_id
      config[:google][:credentials][:private_key] = gcs_private_key if gcs_private_key
    end

  def storage_service # rubocop:disable Metrics/CyclomaticComplexity
    return :amazon if aws_bucket && aws_access_key_id && aws_secret_access_key && aws_region
    return :microsoft if azure_storage_account_name && azure_storage_access_key
    return :google if gcs_private_key_id && gcs_private_key

    Rails.configuration.active_storage.service
  end
end
