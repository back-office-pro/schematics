module Schematics
  class Engine < ::Rails::Engine
    isolate_namespace Schematics

    config.app_generators do |g|
      g.orm :active_record, primary_key_type: :uuid
      g.templates.unshift(File.expand_path('../../templates', __FILE__))
      g.assets          false
      g.template_engine false
      g.helper          false
      g.jbuilder        false
    end

    # Add node_modules to assets paths
    config.assets.paths << 'node_modules'

    # Mailer
    config.action_mailer.delivery_method = :sendmail

    # i18n
    config.i18n.default_locale = :fr
    config.i18n.available_locales = [:fr, :en]

    # Bullet
    config.after_initialize do
      Bullet.enable = true
      Bullet.bullet_logger = true
    end

    # SimpleForm custom bootstrap components
    config.after_initialize do
      SimpleForm.setup do |config|
        config.browser_validations = true
        config.wrapper_mappings = {
          boolean: :custom_boolean_switch,
          check_boxes: :custom_collection,
          date: :custom_multi_select,
          datetime: :custom_multi_select,
          file: :custom_file,
          radio_buttons: :custom_collection,
          range: :custom_range,
          time: :custom_multi_select,
        }
      end
    end

    # Breadcrumbs
    config.after_initialize do
      Loaf.configure do |config|
        config.match = :exact
      end
    end

    # Swagger::Docs
    config.before_eager_load do
      SwaggerUiEngine.configure do |config|
        config.swagger_url = "/api-docs.json"
      end
      Swagger::Docs::Config.base_api_controller = Schematics::SchemaController
      Swagger::Docs::Config.register_apis({
        "1.0" => {
          api_extension_type: :json,
          api_file_path: "public",
          base_path: "http://localhost:3000",
          clean_directory: true,
          camelize_model_properties: true,
          attributes: {
            info: {
              title: "Public API Documentation",
              description: "Developper documentation to link your business application with this API.",
              license: "Apache 2.0",
              licenseUrl: "http://www.apache.org/licenses/LICENSE-2.0.html",
            },
          },
        },
      })
    end

    initializer "schematics.olive_branch" do |app|
      app.middleware.use OliveBranch::Middleware,
                         inflection: "camel",
                         content_type_check: -> (content_type) { true },
                         exclude_response: -> (env) do
                           env['PATH_INFO'].match(/^\/rails\/active_storage\/direct_uploads/)
                         end
    end

    initializer "schematics.cors" do
      Rails.application.config.middleware.insert_before 0, Rack::Cors do
        allow do
          origins '*'
          resource '*',
                   headers: :any,
                   methods: [:get, :post, :put, :patch, :delete, :options, :head]
        end
      end
    end

    initializer "schematics.routes" do
      Rails.application.routes.append do
        mount Schematics::Engine, at: "/"
        mount SwaggerUiEngine::Engine, at: "/api"
      end
    end

    initializer "schematics.rails_monkey_patches" do
      require 'rails/generators/generated_attribute'
      require 'rails/generators/actions'
      require 'active_record/connection_adapters/abstract/schema_definitions'
      Rails::Generators::GeneratedAttribute.
        singleton_class.
        prepend(Schematics::Patches::Rails::Generators::GeneratedAttribute)
      Rails::Generators::GeneratedAttribute.prepend(Schematics::Patches::Rails::Generators::GeneratedAttribute)
      Rails::Generators::Actions.prepend(Schematics::Patches::Rails::Generators::Actions)
      ActiveRecord::ConnectionAdapters::TableDefinition.
        prepend(Schematics::Patches::ActiveRecord::ConnectionAdapters::TableDefinition)
    end

    initializer "schematics.rack_attack" do
      Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
      Rack::Attack.safelist('allow from localhost') do |req|
        '127.0.0.1' == req.ip || '::1' == req.ip
      end
      Rack::Attack.throttle("requests by ip", limit: 5, period: 2) do |request|
        request.ip
      end
      ActiveSupport::Notifications.subscribe("throttle.rack_attack") do |name, start, finish, request_id, payload|
        Rails.logger.info "Throttled IP: #{payload[:request].ip}"
      end
    end

    initializer "schematics.mime_types" do
      Mime::Type.register('application/xls', :xls)
    end

    initializer "schematics.renderers" do
      ActiveSupport.on_load(:action_controller) do
        ActionController::Renderers.add(:schema) do |records, options|
          render json: Schematics::Serializers::JSON.new(SCHEMA, entity).serialize(records)
        end
        ActionController::Renderers.add(:csv) do |records, options|
          send_data Schematics::Serializers::CSV.new(SCHEMA, entity).serialize(records),
                    filename: "#{entity.type.pluralize.dasherize}-#{I18n.l(Date.today)}.csv"
        end
        ActionController::Renderers.add(:xls) do |records, options|
          send_data Schematics::Serializers::CSV.new(SCHEMA, entity).serialize(records, separator: '/t'),
                    filename: "#{entity.type.pluralize.dasherize}-#{I18n.l(Date.today)}.xls"
        end
      end
    end
  end
end
