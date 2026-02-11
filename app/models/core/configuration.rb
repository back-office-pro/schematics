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
  delegate :mailer, to: :class, private: true
  delegate :delivery_method, :settings, to: :mailer, prefix: true, private: true

  after_update_commit :clear_bootstrap_email_sass_cache!
  after_update_commit :update_storage_services!
  after_update_commit :update_mailer_settings!

  validate :active_license

  class << self
    LOCALE_TO_TIME_ZONE = { en: 'UTC', fr: 'Paris', it: 'Rome' }.freeze

    delegate :access_token, :uri_base, :model, :configured?, to: :openai, prefix: true
    delegate :configured?, to: :mailer, prefix: true

    def time_zone_with_fallback
      time_zone || LOCALE_TO_TIME_ZONE[locale&.to_sym]
    end

    def host
      URI(app_url.to_s).host&.delete_prefix('www.') || 'localhost'
    end

    def default_url_options
      { host:, port: }.compact
    end

    def allowed_sources = origins
      .push(app_url)
      .compact

    def license = Schematics::License.build(license_file)

    def license_file = Rails
      .cache
      .fetch('configuration/license_file') { instance.license_file.download }

    memoize def mailer = Schematics::Configuration::Mailer.new(self)

    private

    memoize def openai = Schematics::Configuration::OpenAI.new(self)

    def port
      3000 unless app_url
    end
  end

  def update_storage_services! # rubocop:disable Obsession/Rails/PrivateCallback
    ActiveStorage::Blob.services = ActiveStorage::Service::Registry.new(storage_service_configurations)
    ActiveStorage::Blob.service = ActiveStorage::Blob.services.fetch(storage_service)
  end

  def update_mailer_settings! # rubocop:disable Obsession/Rails/PrivateCallback
    Rails.configuration.action_mailer.delivery_method = mailer_delivery_method
    Rails.configuration.action_mailer.merge!(mailer_settings)
  end

  private

  def clear_bootstrap_email_sass_cache!
    BootstrapEmail.clear_sass_cache! if theme_color_previously_changed?
  end

  def active_license
    return unless attachment_changes['license_file']

    content = attachment_changes['license_file'].attachable.tap(&:rewind).read
    return if Schematics::License.build(content).active?

    errors.add(:license_file)
  end

  memoize def storage = Schematics::Configuration::Storage.new(self)
end
