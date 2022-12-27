# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'backend/postgresql'
require 'backend/redis'

# :reek:Attribute
class Tenant
  class << self
    DEFAULT_BACKEND = 'postgresql'

    delegate :id, :email, to: :customer, prefix: true, allow_nil: true
    attr_writer :schema # rubocop:disable ThreadSafety/ClassAndModuleAttributes

    def schema
      @schema ||= Schematics::Schema.new(data:) # rubocop:disable ThreadSafety/InstanceVariableInClassMethod
    end

    def customer
      @customer ||= ::Stripe::Customer # rubocop:disable ThreadSafety/InstanceVariableInClassMethod
                    .search(query: "name:'#{subdomain}'")
                    .data
                    .first
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
      ::SchemaDataset
        .where(state: 2)
        .last
        .data
        .as_json
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
