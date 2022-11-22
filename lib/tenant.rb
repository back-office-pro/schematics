# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

# :reek:Attribute
class Tenant
  class << self
    delegate :env, :application, to: 'Rails', private: true
    delegate :production?, to: :env, private: true
    attr_writer :current_schema # rubocop:disable ThreadSafety/ClassAndModuleAttributes

    def current_schema
      @current_schema ||= begin # rubocop:disable ThreadSafety/InstanceVariableInClassMethod
        data = (::SchemaDataset.where(state: 2).last.data rescue nil) || [] # rubocop:disable Style/RescueModifier
        Schematics::Schema.new(data:)
      end
    end

    def name = application
      .class
      .module_parent_name
      .underscore

    def folder_name = name.dasherize

    def human = name.humanize

    def index_name(model_name)
      [name, model_name.plural, env].join('_')
    end

    def default_url_options = { host:, port: }.compact

    def default_mailer_options = { from: host }

    private

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
