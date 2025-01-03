# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'pg'
require 'uri'

# :reek:Attribute
class Tenant
  class << self
    DEFAULT_PORT = 3000
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

    def application_record_class
      return ApplicationRecord if defined?(ApplicationRecord)

      ActiveRecord::Base
    end

    def application_controller_class
      return ApplicationController if defined?(ApplicationController)

      ActionController::Base
    end

    def application_job_class
      return ApplicationJob if defined?(ApplicationJob)

      ActiveJob::Base
    end

    def application_mailer_class
      return ApplicationMailer if defined?(ApplicationMailer)

      ActionMailer::Base
    end

    def subdomain = app_name.dasherize

    def domain = ENV.fetch('HOST', 'back-office.pro')

    def url(path: nil) = URI::HTTPS
      .build(host: "www.#{domain}", path:)
      .to_s

    def organization = domain.parameterize

    def human = app_name.humanize

    def default_url_options = { host:, port: }.compact

    def default_mailer_options = { from: "no-reply@#{host}" }

    def ssl_path = Pathname.new("/etc/letsencrypt/live/#{domain}")

    def ssl? = ssl_path.exist?

    def demo? = app_name.eql?('demo') && !Rails.env.test?

    def default_password
      return unless demo?

      'Azerty1234?!'
    end

    def host
      return "#{subdomain}.#{domain}" if Rails.env.production?

      'localhost'
    end

    def port
      DEFAULT_PORT unless Rails.env.production?
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
