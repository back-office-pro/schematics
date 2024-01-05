# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'backend/postgresql'
require 'backend/redis'
require 'search_engine/opensearch'
require 'search_engine/postgresql'

# :reek:Attribute
class Tenant
  DEFAULT_PORT = 3000
  DEFAULT_BACKEND = 'postgresql'
  DEFAULT_SEARCH_ENGINE = 'postgresql'

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

    def backend = Backend
      .const_get(env_backend)
      .new

    def search_engine = SearchEngine
      .const_get(env_search_engine)
      .new

    def name = Rails
      .application
      .class
      .module_parent_name
      .underscore

    def subdomain = name.dasherize

    def domain = 'back-office.pro'

    def url(path: nil) = URI::HTTPS
      .build(host: "www.#{domain}", path:)
      .to_s

    def organization = domain.parameterize

    def human = name.humanize

    def index_name(model_name)
      [name, model_name.plural, Rails.env].join('_')
    end

    def default_url_options = { host:, port: }.compact

    def default_mailer_options = { from: }

    def ssl_path = Pathname.new("/etc/letsencrypt/live/#{domain}")

    def ssl? = ssl_path.exist?

    def demo? = name.eql?('demo') && !Rails.env.test?

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
        .connection
        .execute('SELECT core_version FROM documentations ORDER BY created_at DESC LIMIT 1')
        .getvalue(0, 0)
    rescue StandardError
      Schematics::VERSION
    end

    private

    def data
      JSON.parse ActiveRecord::Base
        .connection
        .execute('SELECT data FROM migrations WHERE state = 2 ORDER BY created_at DESC LIMIT 1')
        .getvalue(0, 0)
    rescue StandardError
      []
    end

    def env_backend = ENV
      .fetch('BACKEND', DEFAULT_BACKEND)
      .camelize
      .to_sym

    def env_search_engine = ENV
      .fetch('SEARCH_ENGINE', DEFAULT_SEARCH_ENGINE)
      .camelize
      .to_sym

    def from = "no-reply@#{host}"

    def port
      DEFAULT_PORT unless Rails.env.production?
    end
  end
end
