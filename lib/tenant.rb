# frozen_string_literal: true

require 'pg'

# :reek:Attribute
class Tenant
  class << self
    SEMAPHORE = Mutex.new.freeze

    def schema
      SEMAPHORE.synchronize do
        @schema ||= Schematics::Schema.new(data:, version:)
      end
    end

    def schema=(value)
      SEMAPHORE.synchronize do
        @schema = value
      end
    end

    def app_name = Rails
      .application
      .class
      .module_parent_name
      .underscore

    def subdomain = app_name.dasherize

    def human = app_name.humanize

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

    def port
      Instance::DEFAULT_PORT unless Rails.env.production?
    end

    def version
      ActiveRecord::Base
        .lease_connection
        .execute('SELECT core_version FROM documentations ORDER BY created_at DESC LIMIT 1')
        .first
        .fetch('core_version')
    rescue StandardError
      Schematics::VERSION
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

    def data
      JSON.parse ActiveRecord::Base
        .lease_connection
        .execute('SELECT data FROM migrations WHERE state = 4 ORDER BY created_at DESC LIMIT 1')
        .first
        .fetch('data')
    rescue StandardError
      []
    end
  end
end
