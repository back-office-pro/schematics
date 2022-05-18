# frozen_string_literal: true

class LocalesGenerator < Rails::Generators::NamedBase # rubocop:disable Metrics/ClassLength
  delegate :available_locales, to: 'Schematics::Engine.config.i18n'

  def create_models_directory
    return if destroying?

    empty_directory(models_path)
  end

  def create_routes_directory
    return if destroying?

    empty_directory(routes_path)
  end

  def create_model_locale_directory
    empty_directory(locale_path)
  end

  def create_route_files
    return if destroying?

    available_locales.each(&method(:create_route_file))
  end

  def create_locale_files
    return if destroying?

    available_locales.each(&method(:create_locale_file))
  end

  def generate_route_locales
    available_locales.each(&method(:append_to_route_file))
  end

  def generate_entity_locales
    return if destroying?

    available_locales.each(&method(:append_to_locale_file))
  end

  private

  def entity = Schematics::Schema
    .instance
    .find_entity_by_name(name.underscore)

  def create_route_file(locale)
    return if File.exist?(route_file_path(locale))

    create_file(route_file_path(locale)) do
      <<~YAML
        ---
        #{locale}:
          routes:
      YAML
    end
  end

  def append_to_route_file(locale)
    append_file(route_file_path(locale)) do
      indent <<~YAML, 4
        #{entity.name.pluralize}: #{translate(entity.name.pluralize, to: locale).parameterize(separator: '_')}
      YAML
    end
  end

  def create_locale_file(locale)
    return if File.exist?(locale_file_path(locale))

    create_file locale_file_path(locale) do
      <<~YAML
        ---
        #{locale}:
          activerecord:
            models:
              #{entity.name}:
                gender: male
                one: #{translate(entity.name, to: locale)}
                other: #{translate(entity.name.pluralize, to: locale)}
            attributes:
              #{entity.name}:
      YAML
    end
  end

  def append_to_locale_file(locale)
    entity.fields.each do |field|
      append_file locale_file_path(locale) do
        indent <<~YAML, 8
          #{field.name}: #{translate(field.name, to: locale)}
        YAML
      end
    end
    entity.enum_attributes.each do |enum|
      append_file locale_file_path(locale) do
        indent <<~YAML, 8
          #{enum.name.pluralize}:
        YAML
      end
      enum.values.each do |value|
        append_file locale_file_path(locale) do
          indent <<~YAML, 10
            #{value}: #{translate(value, to: locale)}
          YAML
        end
      end
      next unless enum.is_a?(Schematics::Attributes::StateMachine)

      append_file locale_file_path(locale) do
        indent <<~YAML, 4
          events:
            #{entity.name}:
        YAML
      end
      enum.events.map(&:name).each do |event|
        append_file locale_file_path(locale) do
          indent <<~YAML, 8
            #{event}: #{translate(event, to: locale)}
          YAML
        end
      end
    end
  end

  def translate(text, to:)
    EasyTranslate.translate(
      text.titleize,
      to:,
      key: Schematics::Engine.credentials.gcloud[:api_key]
    )
  rescue EasyTranslate::EasyTranslateException
    text.titleize
  end

  def destroying?
    behavior == :revoke
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

  def locale_path
    File.join(models_path, entity.name)
  end

  def locale_file_path(locale)
    File.join(locale_path, "#{locale}.yml")
  end

  def route_file_path(locale)
    File.join(routes_path, "#{locale}.yml")
  end
end
