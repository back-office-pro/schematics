# frozen_string_literal: true

class Tenant
  class << self
    delegate :env, :application, to: 'Rails', private: true

    def name = application
      .class
      .module_parent_name
      .underscore

    def folder_name = name.dasherize

    def human = name.humanize

    def index_name(model_name)
      [name, model_name.plural, env].join('_')
    end

    def app_env = dummy? ? :development : :production

    private

    def dummy? = name == 'dummy'
  end
end
