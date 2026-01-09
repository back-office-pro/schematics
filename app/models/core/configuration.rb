# Copyright © 2025 Dev & Software. All rights reserved.

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

  delegate :service, :service_configurations, to: :storage, prefix: true, private: true

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
    ActiveStorage::Blob.services = ActiveStorage::Service::Registry.new(storage_service_configurations)
    ActiveStorage::Blob.service = ActiveStorage::Blob.services.fetch(storage_service)
  end

  private

  def clear_bootstrap_email_sass_cache!
    BootstrapEmail.clear_sass_cache! if theme_color_previously_changed?
  end

  memoize def storage = Schematics::Configuration::Storage.new(self)
end
