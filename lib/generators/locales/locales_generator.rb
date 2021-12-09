# frozen_string_literal: true

class LocalesGenerator < Rails::Generators::Base
  delegate :available_locales, to: 'Schematics::Engine.config.i18n'
  delegate :entities, to: 'Schematics::Schema.instance'

  def generate_route_locales
    available_locales.each(&method(:generate_route_locale))
  end

  def generate_entity_locales
    available_locales.each(&method(:generate_entity_locale))
  end

  private

  def generate_entity_locale(locale)
    empty_directory(models_path)
    entities.reject(&:core?).each do |entity|
      empty_directory locale_path(entity)
      create_locale_file(entity, locale)
      append_to_locale_file(entity, locale)
    end
  end

  def generate_route_locale(locale)
    empty_directory(routes_path)
    create_route_file(locale)
    entities.reject(&:core?).each do |entity|
      append_to_route_file(entity, locale)
    end
  end

  def create_route_file(locale)
    create_file(route_file_path(locale)) do
      <<~YAML
        ---
        #{locale}:
          routes:
      YAML
    end
  end

  def append_to_route_file(entity, locale)
    append_file(route_file_path(locale)) do
      indent <<~YAML, 4
        #{entity.name.pluralize}: #{translate(entity.name.pluralize, to: locale).parameterize(separator: '_')}
      YAML
    end
  end

  def create_locale_file(entity, locale)
    create_file locale_file_path(entity, locale) do
      <<~YAML
        ---
        #{locale}:
          activerecord:
            models:
              #{entity.name}:
                one: #{translate(entity.name, to: locale)}
                other: #{translate(entity.name.pluralize, to: locale)}
            attributes:
              #{entity.name}:
      YAML
    end
  end

  def append_to_locale_file(entity, locale)
    entity.fields.each do |field|
      append_file locale_file_path(entity, locale) do
        indent <<~YAML, 8
          #{field.name}: #{translate(field.name, to: locale)}
        YAML
      end
    end
    entity.enum_attributes.each do |enum|
      append_file locale_file_path(entity, locale) do
        indent <<~YAML, 8
          #{enum.name.pluralize}:
        YAML
      end
      enum.values.each do |value|
        append_file locale_file_path(entity, locale) do
          indent <<~YAML, 10
            #{value}: #{translate(value, to: locale)}
          YAML
        end
      end
    end
  end

  def translate(text, to:)
    return text.titleize unless Rails.env.production?

    EasyTranslate.translate(
      text.titleize,
      to:,
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
