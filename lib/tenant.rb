# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'search_engine/opensearch'
require 'search_engine/postgresql'

# :reek:Attribute
class Tenant
  DEFAULT_PORT = 3000
  DEFAULT_SEARCH_ENGINE = :Postgresql

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

    def search_engine
      SEMAPHORE.synchronize do
        @search_engine ||= SearchEngine.const_get(search_engine_name).new
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

    def domain = 'back-office.pro'

    def url(path: nil) = URI::HTTPS
      .build(host: "www.#{domain}", path:)
      .to_s

    def organization = domain.parameterize

    def human = app_name.humanize

    def index_name(model_name)
      [app_name, model_name.plural, Rails.env].join('_')
    end

    def default_url_options = { host:, port: }.compact

    def default_mailer_options = { from: }

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

    def version
      ActiveRecord::Base
        .lease_connection
        .execute('SELECT core_version FROM documentations ORDER BY created_at DESC LIMIT 1')
        .getvalue(0, 0)
    rescue StandardError
      Schematics::VERSION
    end

    private

    def data
      JSON.parse ActiveRecord::Base
        .lease_connection
        .execute('SELECT data FROM migrations WHERE state = 3 ORDER BY created_at DESC LIMIT 1')
        .getvalue(0, 0)
    rescue StandardError
      []
    end

    def search_engine_name
      [DEFAULT_SEARCH_ENGINE, :Opensearch].at(
        ActiveRecord::Base
          .lease_connection
          .execute("SELECT metadata -> 'databases' FROM subscriptions")
          .getvalue(0, 0)
          .to_i
          .pred
      )
    rescue StandardError
      DEFAULT_SEARCH_ENGINE
    end

    def from = "no-reply@#{host}"

    def port
      DEFAULT_PORT unless Rails.env.production?
    end
  end
end
