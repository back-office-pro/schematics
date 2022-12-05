# frozen_string_literal: true

module Schematics
  # :reek:MissingSafeMethod
  class Tenant
    include ::ActiveModel::API
    include ::ActiveModel::Attributes

    delegate :id, :email, to: :customer, prefix: true, allow_nil: true
    attribute :name, default: -> { Rails.application.class.module_parent_name.underscore }

    class << self
      SEMAPHORE = Mutex.new.freeze

      def current
        SEMAPHORE.synchronize do
          @current ||= new
        end
      end
    end

    def schema
      @schema ||= Schematics::Schema.new(data:)
    end

    def reset!
      @schema = nil
    end

    def customer
      @customer ||= ::Stripe::Customer
                    .search(query: "name:'#{subdomain}'")
                    .data
                    .first
    end

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
        .where(state: [1, 2])
        .last
        .data
        .as_json
    rescue StandardError
      []
    end

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
