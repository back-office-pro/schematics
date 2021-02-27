class LocalesGenerator < Rails::Generators::Base
  delegate :translate, to: :client, private: true

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
            #{entity.name.pluralize}: #{translate(entity.name.pluralize, to: locale)}
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
                  #{entity.name}: #{translate(entity.name, to: locale)}
                attributes:
                  #{entity.name}:
          YAML
        end
        entity.fields.each do |field|
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
      key: Schematics::Engine.credentials.gcloud[:api_key]
    )
  end

  def locales_path
    File.join('config', 'locales')
  end

  def models_path
    File.join(locales_path, 'models')
  end

  def routes_path
    File.join(locales_path, 'routes')
  end

  def locale_path(entity)
    File.join(models_path, entity.name)
  end

  def locale_file_path(entity, locale)
    File.join(locale_path(entity), "#{locale}.yml")
  end

  def route_file_path(locale)
    File.join(routes_path, "#{locale}.yml")
  end
end
