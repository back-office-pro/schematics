# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

# :reek:MissingSafeMethod
class ::Configuration < Schematics::ApplicationRecord
  attribute :available_locales, default: -> { [Rails.configuration.i18n.default_locale] }
  attribute :locale, default: -> { Rails.configuration.i18n.default_locale }

  after_update_commit :clear_bootstrap_email_sass_cache!
  after_update_commit :update_storage_services!

  class << self
    LOCALE_TO_TIME_ZONE = { en: 'UTC', fr: 'Paris', it: 'Rome' }.freeze

    def time_zone_with_fallback
      time_zone || LOCALE_TO_TIME_ZONE[locale&.to_sym]
    end

    def host
      URI(company_website.to_s).host&.delete_prefix('www.') || 'localhost'
    end

    def default_url_options
      { host:, port: }.compact
    end

    def allowed_sources = origins
      .push(company_website)
      .compact

    def storage_quota_will_be_exceeded?(size)
      return false unless storage_quota

      storage_size.bytes + size.bytes >= storage_quota.gigabytes
    end

    def license = Schematics::License.build(license_file)

    def license_file = Rails
      .cache
      .fetch('configuration/license_file') { instance.license_file.download }

    private

    memoize def storage_size = ActiveStorage::Blob
      .with_deleted
      .sum(&:byte_size)

    def port
      3000 unless company_website
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

  def storage_configurations = ActiveSupport::ConfigurationFile # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
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

  def storage_service # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    return :amazon if aws_bucket && aws_access_key_id && aws_secret_access_key && aws_region
    return :microsoft if azure_storage_account_name && azure_storage_access_key
    return :google if gcs_private_key_id && gcs_private_key

    Rails.configuration.active_storage.service
  end
end
