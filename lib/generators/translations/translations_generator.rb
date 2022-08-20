# frozen_string_literal: true

class TranslationsGenerator < Rails::Generators::NamedBase # rubocop:disable Metrics/ClassLength
  delegate :available_locales, to: 'Schematics::Engine.config.i18n'
  delegate :credentials, to: 'Schematics::Engine'

  def generate_route_translations
    key = "routes.#{entity.name.pluralize}"
    case behavior
    in :invoke
      PaperTrail.request(enabled: false) do
        available_locales.each do |locale|
          Translation.create!(
            locale:,
            key:,
            value: translate(entity.name.pluralize, locale:).parameterize(separator: '-')
          )
        end
      end
    in :revoke
      PaperTrail.request(enabled: false) do
        available_locales.each do |locale|
          Translation.destroy_by(locale:, key:)
        end
      end
    end
  end

  def generate_model_gender_translations
    key = "activerecord.models.#{entity.name}.gender"
    case behavior
    in :invoke
      PaperTrail.request(enabled: false) do
        available_locales.each do |locale|
          Translation.create!(locale:, key:, value: 'male')
        end
      end
    in :revoke
      PaperTrail.request(enabled: false) do
        available_locales.each do |locale|
          Translation.destroy_by(locale:, key:)
        end
      end
    end
  end

  def generate_model_singular_translations
    key = "activerecord.models.#{entity.name}.one"
    case behavior
    in :invoke
      PaperTrail.request(enabled: false) do
        available_locales.each do |locale|
          Translation.create!(locale:, key:, value: translate(entity.name, locale:))
        end
      end
    in :revoke
      PaperTrail.request(enabled: false) do
        available_locales.each do |locale|
          Translation.destroy_by(locale:, key:)
        end
      end
    end
  end

  def generate_model_plural_translations
    key = "activerecord.models.#{entity.name}.other"
    case behavior
    in :invoke
      PaperTrail.request(enabled: false) do
        available_locales.each do |locale|
          Translation.create!(locale:, key:, value: translate(entity.name.pluralize, locale:))
        end
      end
    in :revoke
      PaperTrail.request(enabled: false) do
        available_locales.each do |locale|
          Translation.destroy_by(locale:, key:)
        end
      end
    end
  end

  def generate_model_attributes_translations
    case behavior
    in :invoke
      PaperTrail.request(enabled: false) do
        available_locales.each do |locale|
          entity.fields.each do |field|
            Translation.create!(
              locale:,
              key: "activerecord.attributes.#{entity.name}.#{field.name}",
              value: translate(field.name, locale:)
            )
          end
        end
      end
    in :revoke
      PaperTrail.request(enabled: false) do
        available_locales.each do |locale|
          entity.fields.each do |field|
            Translation.destroy_by(
              locale:,
              key: "activerecord.attributes.#{entity.name}.#{field.name}"
            )
          end
        end
      end
    end
  end

  def generate_model_enums_translations # rubocop:disable Metrics/CyclomaticComplexity,  Metrics/MethodLength, Metrics/PerceivedComplexity
    case behavior
    in :invoke
      PaperTrail.request(enabled: false) do
        available_locales.each do |locale|
          entity.enum_attributes.each do |enum|
            enum.values.each do |value|
              Translation.create!(
                locale:,
                key: "activerecord.attributes.#{entity.name}.#{enum.name.pluralize}.#{value}",
                value: translate(value, locale:)
              )
            end
            next unless enum.is_a?(Schematics::Attributes::StateMachine)

            enum.events.map(&:name).each do |event|
              Translation.create!(
                locale:,
                key: "activerecord.events.#{entity.name}.#{event}",
                value: translate(event, locale:)
              )
            end
          end
        end
      end
    in :revoke
      PaperTrail.request(enabled: false) do
        available_locales.each do |locale|
          entity.enum_attributes.each do |enum|
            enum.values.each do |value|
              Translation.destroy_by(
                locale:,
                key: "activerecord.attributes.#{entity.name}.#{enum.name.pluralize}.#{value}"
              )
            end
            next unless enum.is_a?(Schematics::Attributes::StateMachine)

            enum.events.map(&:name).each do |event|
              Translation.destroy_by(locale:, key: "activerecord.events.#{entity.name}.#{event}")
            end
          end
        end
      end
    end
  end

  private

  def entity = Schematics::Schema
    .instance
    .find_entity_by_name(name.underscore)

  # :reek:FeatureEnvy
  def translate(text, locale:)
    EasyTranslate.translate(text.humanize, to: locale, key: credentials.gcloud[:api_key])
  rescue EasyTranslate::EasyTranslateException
    text.humanize
  end
end
