# frozen_string_literal: true

require 'pg'

class Tenant
  class << self
    delegate :port, to: Instance, private: true

    def app_name = Rails
      .application
      .class
      .module_parent_name
      .underscore

    def subdomain = app_name.dasherize

    def default_url_options = { host:, port: }.compact

    def default_mailer_options = { from: "no-reply@#{host}" }

    def demo? = app_name.eql?('demo') && !Rails.env.test?

    def default_password
      'Azerty1234?!!' if demo?
    end

    def host
      return "#{subdomain}.#{Instance.domain}" if Rails.env.production?

      'localhost'
    end

    def database = %i[sqlite3 postgresql][database_index]

    private

    def database_index
      PG
        .connect(connect_timeout: 1)
        .exec("SELECT 1 FROM pg_database WHERE datname='#{app_name}_#{Rails.env}'")
        .count
    rescue PG::Error
      0
    end
  end
end
