# frozen_string_literal: true

class Tenant
  class << self
    delegate :env, :application, to: 'Rails', private: true

    def folder_name = namespace.dasherize

    def human = namespace.humanize

    def index_name(model_name)
      [namespace, model_name.plural, env].join('_')
    end

    def app_env = dummy? ? :development : :production

    def redis_options = {
      url: ENV.fetch('REDIS_URL', 'redis://localhost:6379'),
      namespace:
    }

    private

    def dummy? = namespace == 'dummy'

    def namespace = application
      .class
      .module_parent_name
      .underscore
  end
end
