# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'backend/postgresql'
require 'backend/redis'

# :reek:Attribute
class Tenant
  class << self
    DEFAULT_BACKEND = 'postgresql'

    delegate :id, :email, to: :customer, prefix: true, allow_nil: true
    delegate :mutex, to: :backend, private: true

    def schema
      mutex.synchronize do
        @schema ||= Schematics::Schema.new(data:)
      end
    end

    def schema=(value)
      mutex.synchronize do
        @schema = value
      end
    end

    def customer
      Rails.cache.fetch('stripe:customer') do
        ::Stripe::Customer
          .search(query: "name:'#{subdomain}'")
          .data
          .first
      end
    end

    def backend = Backend
      .const_get(env_backend)
      .new

    def name = Rails
      .application
      .class
      .module_parent_name
      .underscore

    def subdomain = name.dasherize

    def human = name.humanize

    def index_name(model_name)
      [name, model_name.plural, Rails.env].join('_')
    end

    def default_url_options = { host:, port: }.compact

    def default_mailer_options = { from: }

    def nginx_sites_available_path = "/etc/nginx/sites-available/#{subdomain}"

    def nginx_sites_enabled_path = "/etc/nginx/sites-enabled/#{subdomain}"

    def customer_locale = customer
      &.preferred_locales
      &.first
      &.slice(0, 2)

    private

    def data
      JSON.parse ActiveRecord::Base
        .connection
        .execute('SELECT data FROM schema_datasets WHERE state = 2 ORDER BY created_at DESC LIMIT 1') # rubocop:disable Layout/LineLength
        .getvalue(0, 0)
    rescue StandardError
      []
    end

    def env_backend = ENV
      .fetch('BACKEND', DEFAULT_BACKEND)
      .camelize
      .to_sym

    def from = "no-reply@#{host}"

    def host
      return "#{subdomain}.back-office.pro" if Rails.env.production?

      'localhost'
    end

    def port
      return if Rails.env.production?

      ENV
        .fetch('PORT', 3000)
        .to_i
    end
  end
end
