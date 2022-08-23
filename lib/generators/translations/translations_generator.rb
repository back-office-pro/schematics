# frozen_string_literal: true

class TranslationsGenerator < Rails::Generators::NamedBase # rubocop:disable Metrics/ClassLength
  delegate :available_locales, to: 'Schematics::Engine.config.i18n'
  delegate :credentials, to: 'Schematics::Engine'
  class_option :rename, type: :string

  def generate_route_translations
    return unless behavior == :invoke

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        ::Translation.create!(
          locale:,
          key: "routes.#{entity.name.pluralize}",
          value: translate(entity.name.pluralize, locale:).parameterize(separator: '-')
        )
      end
    end
  end

  def destroy_route_translations
    return unless behavior == :revoke

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        ::Translation.destroy_by(locale:, key: "routes.#{entity.name.pluralize}")
      end
    end
  end

  def rename_route_translations
    return unless behavior == :reinvoke

    PaperTrail.request(enabled: false) do
      ::Translation
        .where(key: "routes.#{old_name.pluralize}")
        .update_all(key: "routes.#{entity.name.pluralize}") # rubocop:disable Rails/SkipsModelValidations
    end
  end

  def generate_model_gender_translations
    return unless behavior == :invoke

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        ::Translation.create!(
          locale:,
          key: "activerecord.models.#{entity.name}.gender",
          value: 'male'
        )
      end
    end
  end

  def destroy_model_gender_translations
    return unless behavior == :revoke

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        ::Translation.destroy_by(
          locale:,
          key: "activerecord.models.#{entity.name}.gender"
        )
      end
    end
  end

  def rename_model_gender_translations
    return unless behavior == :reinvoke

    PaperTrail.request(enabled: false) do
      ::Translation
        .where(key: "activerecord.models.#{old_name}.gender")
        .update_all(key: "activerecord.models.#{entity.name}.gender") # rubocop:disable Rails/SkipsModelValidations
    end
  end

  def generate_model_singular_translations
    return unless behavior == :invoke

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        ::Translation.create!(
          locale:,
          key: "activerecord.models.#{entity.name}.one",
          value: translate(entity.name, locale:)
        )
      end
    end
  end

  def destroy_model_singular_translations
    return unless behavior == :revoke

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        ::Translation.destroy_by(locale:, key: "activerecord.models.#{entity.name}.one")
      end
    end
  end

  def rename_model_singular_translations
    return unless behavior == :reinvoke

    PaperTrail.request(enabled: false) do
      ::Translation
        .where(key: "activerecord.models.#{old_name}.one")
        .update_all(key: "activerecord.models.#{entity.name}.one") # rubocop:disable Rails/SkipsModelValidations
    end
  end

  def generate_model_plural_translations
    return unless behavior == :invoke

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        ::Translation.create!(
          locale:,
          key: "activerecord.models.#{entity.name}.other",
          value: translate(entity.name.pluralize, locale:)
        )
      end
    end
  end

  def destroy_model_plural_translations
    return unless behavior == :revoke

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        ::Translation.destroy_by(locale:, key: "activerecord.models.#{entity.name}.other")
      end
    end
  end

  def rename_model_plural_translations
    return unless behavior == :reinvoke

    PaperTrail.request(enabled: false) do
      ::Translation
        .where(key: "activerecord.models.#{old_name}.other")
        .update_all(key: "activerecord.models.#{entity.name}.other") # rubocop:disable Rails/SkipsModelValidations
    end
  end

  def generate_model_attributes_translations
    return unless behavior == :invoke

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        entity.fields.each do |field|
          ::Translation.create!(
            locale:,
            key: "activerecord.attributes.#{entity.name}.#{field.name}",
            value: translate(field.name, locale:)
          )
        end
      end
    end
  end

  def destroy_model_attributes_translations
    return unless behavior == :revoke

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        entity.fields.each do |field|
          ::Translation.destroy_by(
            locale:,
            key: "activerecord.attributes.#{entity.name}.#{field.name}"
          )
        end
      end
    end
  end

  def rename_model_attributes_translations
    return unless behavior == :reinvoke

    PaperTrail.request(enabled: false) do
      entity.fields.each do |field|
        ::Translation
          .where(key: "activerecord.attributes.#{old_name}.#{field.name}")
          .update_all(key: "activerecord.attributes.#{entity.name}.#{field.name}") # rubocop:disable Rails/SkipsModelValidations
      end
    end
  end

  def generate_model_enums_translations # rubocop:disable Metrics/CyclomaticComplexity
    return unless behavior == :invoke

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        entity.enum_attributes.each do |enum|
          enum.values.each do |value|
            ::Translation.create!(
              locale:,
              key: "activerecord.attributes.#{entity.name}.#{enum.name.pluralize}.#{value}",
              value: translate(value, locale:)
            )
          end
          next unless enum.is_a?(Schematics::Attributes::StateMachine)

          enum.events.map(&:name).each do |event|
            ::Translation.create!(
              locale:,
              key: "activerecord.events.#{entity.name}.#{event}",
              value: translate(event, locale:)
            )
          end
        end
      end
    end
  end

  def destroy_model_enums_translations # rubocop:disable Metrics/CyclomaticComplexity
    return unless behavior == :revoke

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        entity.enum_attributes.each do |enum|
          enum.values.each do |value|
            ::Translation.destroy_by(
              locale:,
              key: "activerecord.attributes.#{entity.name}.#{enum.name.pluralize}.#{value}"
            )
          end
          next unless enum.is_a?(Schematics::Attributes::StateMachine)

          enum.events.map(&:name).each do |event|
            ::Translation.destroy_by(locale:, key: "activerecord.events.#{entity.name}.#{event}")
          end
        end
      end
    end
  end

  def rename_model_enums_translations
    return unless behavior == :reinvoke

    PaperTrail.request(enabled: false) do
      entity.enum_attributes.each do |enum|
        enum.values.each do |value|
          ::Translation
            .where(key: "activerecord.attributes.#{old_name}.#{enum.name.pluralize}.#{value}")
            .update_all(key: "activerecord.attributes.#{entity.name}.#{enum.name.pluralize}.#{value}") # rubocop:disable Rails/SkipsModelValidations, Layout/LineLength
        end
        next unless enum.is_a?(Schematics::Attributes::StateMachine)

        enum.events.map(&:name).each do |event|
          ::Translation
            .where(key: "activerecord.events.#{old_name}.#{event}")
            .update_all(key: "activerecord.events.#{entity.name}.#{event}") # rubocop:disable Rails/SkipsModelValidations
        end
      end
    end
  end

  private

  def entity = Schematics::Schema
    .instance
    .find_entity_by_name(name.underscore)

  def old_name = options[:rename]

  # :reek:FeatureEnvy
  def translate(text, locale:)
    EasyTranslate.translate(text.humanize, to: locale, key: credentials.gcloud[:api_key])
  rescue EasyTranslate::EasyTranslateException
    text.humanize
  end
end
