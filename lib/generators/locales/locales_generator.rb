class LocalesGenerator < Rails::Generators::Base
  delegate :translate, to: :client

  LOCALES = [:fr].freeze

  def generate_route_locales
    LOCALES.each do |locale|
      empty_directory(routes_path)
      create_file(route_file_path(locale)) do
        <<~YAML
        fr:
          routes:
        YAML
      end
      Schematics::SCHEMA.entities.each do |entity|
        append_file(route_file_path(locale)) do
          indent <<~YAML, 4
            #{entity.type.pluralize}: #{translate(entity.type.pluralize, to: locale)}
          YAML
        end
      end
    end
  end

  def generate_entity_locales
    LOCALES.each do |locale|
      empty_directory(models_path)
      Schematics::SCHEMA.entities.each do |entity|
        empty_directory locale_path(entity)
        create_file locale_file_path(entity, locale) do
          <<~YAML
          fr:
            activerecord:
              models:
                #{entity.type}: #{translate(entity.type, to: locale)}
              attributes:
                #{entity.type}:
          YAML
        end
        (entity.attributes + entity.virtuals).each do |field|
          append_file locale_file_path(entity, locale) do
            indent <<~YAML, 8
              #{field.name}: #{translate(field.name, to: locale)}
            YAML
          end
        end
      end
    end
  end

  private

  def client
    @client ||= Google::Cloud::Translate.new(
      version: :v2,
      key: "AIzaSyDZq17OV7t46iVxVrVweZaPMuMa7tM67PI"
      # project_id: "schematics-273718",
      # credentials: File.expand_path('../../../config/google-cloud.json', __dir__),
    )
  end

  def locales_path
    File.join("config", "locales")
  end

  def models_path
    File.join(locales_path, "models")
  end

  def routes_path
    File.join(locales_path, "routes")
  end

  def locale_path(entity)
    File.join(models_path, entity.type)
  end

  def locale_file_path(entity, locale)
    File.join(locale_path(entity), "#{locale}.yml")
  end

  def route_file_path(locale)
    File.join(routes_path, "#{locale}.yml")
  end
end
