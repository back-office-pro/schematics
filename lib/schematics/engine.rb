module Schematics
  class Engine < ::Rails::Engine
    isolate_namespace Schematics

    config.app_generators do |g|
      g.orm :active_record, primary_key_type: :uuid
      g.templates.unshift(File.expand_path('../templates', __dir__))
      g.assets          false
      g.template_engine false
      g.helper          false
      g.jbuilder        false
    end

    # Mailer
    config.action_mailer.delivery_method = :sendmail
    config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

    # i18n
    config.i18n.default_locale = :fr
    config.i18n.available_locales = [:fr, :en]
    config.i18n.load_path += Dir.glob(File.expand_path('../../config/locales/**/*.yml', __dir__))

    # Assets
    config.assets.precompile += %w(schematics/themes/*.css)

    # Bullet
    config.after_initialize do
      Bullet.enable = true
      # TODO
      # remove unused_eager_loading_enable if https://github.com/flyerhzm/bullet/issues/147
      # and https://github.com/flyerhzm/bullet/issues/467 are fixed
      Bullet.unused_eager_loading_enable = false
      Bullet.raise = !Rails.env.production?
      Bullet.bullet_logger = Rails.env.production?
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
    config.after_initialize do
      SwaggerUiEngine.configure do |config|
        config.swagger_url = "/api-docs.json"
      end
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
              description: "Developper documentation to link your application with this API.",
              license: "Apache 2.0",
              licenseUrl: "http://www.apache.org/licenses/LICENSE-2.0.html",
            },
          },
        },
      })
    end

    initializer "schematics.chartkick" do
      Chartkick.options = {
        # colors: ['#2C3E50', '#ecf0f1'],
        height: '300px',
      }
    end

    initializer "schematics.oj" do
      Oj::Rails.set_encoder
      Oj::Rails.set_decoder
      Oj::Rails.optimize
    end

    initializer "schematics.active_model_serializers" do
      ActiveModelSerializers.config.key_transform = :camel_lower
    end

    initializer "schematics.route_translator" do
      RouteTranslator.config do |config|
        config.hide_locale = true
      end
    end

    initializer "schematics.cors" do |app|
      app.config.middleware.insert_before 0, Rack::Cors do
        allow do
          origins '*'
          resource '*',
                   headers: :any,
                   methods: [:get, :post, :put, :patch, :delete, :options, :head]
        end
      end
    end

    initializer "schematics.routes" do |app|
      app.routes.default_url_options = app.config.action_mailer.default_url_options
      app.routes.append do
        mount Schematics::Engine, at: "/"
        mount SwaggerUiEngine::Engine, at: "/api"
      end
    end

    initializer "schematics.rails_monkey_patches" do
      require 'rails/generators/generated_attribute'
      require 'rails/generators/actions'
      require 'active_record/connection_adapters/abstract/schema_definitions'
      Rails::Generators::GeneratedAttribute.singleton_class.
        prepend(Schematics::Patches::Rails::Generators::GeneratedAttribute)
      Rails::Generators::GeneratedAttribute.
        prepend(Schematics::Patches::Rails::Generators::GeneratedAttribute)
      Rails::Generators::Actions.
        prepend(Schematics::Patches::Rails::Generators::Actions)
      ActiveRecord::ConnectionAdapters::TableDefinition.
        prepend(Schematics::Patches::ActiveRecord::ConnectionAdapters::TableDefinition)
    end

    initializer "schematics.acts_as_paranoid" do
      require 'action_text/rich_text'
      require 'active_storage/attachment'
      ActiveSupport.on_load(:action_text_rich_text) do
        ActionText::RichText.class_eval do
          acts_as_paranoid
        end
      end
      ActiveSupport.on_load(:active_storage_attachment) do
        ActiveStorage::Attachment.class_eval do
          acts_as_paranoid
        end
      end
      ActiveSupport.on_load(:active_storage_blob) do
        ActiveStorage::Blob.class_eval do
          acts_as_paranoid
        end
      end
    end

    initializer "schematics.rack_attack" do
      Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
      Rack::Attack.safelist('allow from localhost') do |req|
        '127.0.0.1' == req.ip || '::1' == req.ip
      end
      Rack::Attack.throttle("requests by ip", limit: 5, period: 2) do |request|
        request.ip
      end
      ActiveSupport::Notifications.
        subscribe("throttle.rack_attack") do |name, start, finish, request_id, payload|
          Rails.logger.info "Throttled IP: #{payload[:request].ip}"
        end
    end

    initializer "schematics.mime_types" do
      Mime::Type.register('application/xls', :xls)
    end

    initializer "schematics.renderers" do
      ActiveSupport.on_load(:action_controller) do
        ActionController::Renderers.add(:csv) do |records, options|
          filename = "#{model_name.human.downcase.pluralize.dasherize}-#{I18n.l(Time.current)}.csv"
          send_data Schematics::CsvSerializer.new(records).to_csv, filename: filename
        end
        ActionController::Renderers.add(:xls) do |records, options|
          filename = "#{model_name.human.downcase.pluralize.dasherize}-#{I18n.l(Time.current)}.xls"
          send_data Schematics::CsvSerializer.new(records).to_xls, filename: filename
        end
      end
    end
  end
end
