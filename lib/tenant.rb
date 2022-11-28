# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

# :reek:Attribute
# :reek:MissingSafeMethod
class Tenant
  class << self
    delegate :env, :application, to: 'Rails', private: true
    delegate :production?, to: :env, private: true

    def schema
      @schema ||= Schematics::Schema.new(data:) # rubocop:disable ThreadSafety/InstanceVariableInClassMethod
    end

    def reset!
      @schema = nil # rubocop:disable ThreadSafety/InstanceVariableInClassMethod
    end

    def name = application
      .class
      .module_parent_name
      .underscore

    def subdomain = name.dasherize

    def human = name.humanize

    def index_name(model_name)
      [name, model_name.plural, env].join('_')
    end

    def default_url_options = { host:, port: }.compact

    def default_mailer_options = { from: }

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
      return "#{name}.back-office.pro" if production?

      'localhost'
    end

    def port
      return if production?

      ENV
        .fetch('PORT', 3000)
        .to_i
    end
  end
end
