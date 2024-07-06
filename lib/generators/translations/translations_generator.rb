# frozen_string_literal: true

class TranslationsGenerator < Rails::Generators::NamedBase # rubocop:disable Metrics/ClassLength
  delegate :available_locales, to: I18n
  class_option :rename, type: :string

  def generate_model_gender_translations
    return unless generating?

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        Translation.create!(
          locale:,
          key: "activerecord.models.#{entity.name}.gender",
          value: 'male'
        )
      end
    end
  end

  def destroy_model_gender_translations
    return unless destroying?

    PaperTrail.request(enabled: false) do
      Translation.delete_by(
        locale: available_locales,
        key: "activerecord.models.#{entity.name}.gender"
      )
    end
  end

  def rename_model_gender_translations
    return unless renaming?

    PaperTrail.request(enabled: false) do
      Translation
        .where(key: "activerecord.models.#{old_name}.gender")
        .update_all(key: "activerecord.models.#{entity.name}.gender") # rubocop:disable Rails/SkipsModelValidations
    end
  end

  def generate_model_singular_translations
    return unless generating?

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        Translation.create!(
          locale:,
          key: "activerecord.models.#{entity.name}.one",
          value: translate(entity.name, locale:)
        )
      end
    end
  end

  def destroy_model_singular_translations
    return unless destroying?

    PaperTrail.request(enabled: false) do
      Translation.delete_by(
        locale: available_locales,
        key: "activerecord.models.#{entity.name}.one"
      )
    end
  end

  def rename_model_singular_translations
    return unless renaming?

    PaperTrail.request(enabled: false) do
      Translation
        .where(key: "activerecord.models.#{old_name}.one")
        .update_all(key: "activerecord.models.#{entity.name}.one") # rubocop:disable Rails/SkipsModelValidations
    end
  end

  def generate_model_plural_translations
    return unless generating?

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        Translation.create!(
          locale:,
          key: "activerecord.models.#{entity.name}.other",
          value: translate(entity.name.pluralize, locale:)
        )
      end
    end
  end

  def destroy_model_plural_translations
    return unless destroying?

    PaperTrail.request(enabled: false) do
      Translation.delete_by(
        locale: available_locales,
        key: "activerecord.models.#{entity.name}.other"
      )
    end
  end

  def rename_model_plural_translations
    return unless renaming?

    PaperTrail.request(enabled: false) do
      Translation
        .where(key: "activerecord.models.#{old_name}.other")
        .update_all(key: "activerecord.models.#{entity.name}.other") # rubocop:disable Rails/SkipsModelValidations
    end
  end

  def generate_model_attributes_translations
    return unless generating?

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        entity.fields.concat(entity.has_and_belongs_to_many_associations).each do |element|
          Translation.create!(
            locale:,
            key: element.i18n_key,
            value: translate(element.name, locale:)
          )
        end
      end
    end
  end

  def destroy_model_attributes_translations
    return unless destroying?

    PaperTrail.request(enabled: false) do
      entity.fields.concat(entity.has_and_belongs_to_many_associations).each do |element|
        Translation.delete_by(locale: available_locales, key: element.i18n_key)
      end
    end
  end

  def rename_model_attributes_translations
    return unless renaming?

    PaperTrail.request(enabled: false) do
      entity.fields.concat(entity.has_and_belongs_to_many_associations).each do |element|
        Translation
          .where(key: "activerecord.attributes.#{old_name}.#{element.name}")
          .update_all(key: element.i18n_key) # rubocop:disable Rails/SkipsModelValidations
      end
    end
  end

  def generate_model_enums_translations
    return unless generating?

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        entity.enum_attributes.each do |enum|
          enum.values.each do |value|
            Translation.create!(
              locale:,
              key: "activerecord.enums.#{entity.name}.#{enum.name}.#{value}",
              value: translate(value, locale:)
            )
          end
          next unless enum in Schematics::Attributes::StateMachine

          enum.events.each do |event|
            Translation.create!(
              locale:,
              key: event.i18n_key,
              value: translate(event.name, locale:)
            )
          end
        end
      end
    end
  end

  def destroy_model_enums_translations
    return unless destroying?

    PaperTrail.request(enabled: false) do
      entity.enum_attributes.each do |enum|
        enum.values.each do |value|
          Translation.delete_by(
            locale: available_locales,
            key: "activerecord.enums.#{entity.name}.#{enum.name}.#{value}"
          )
        end
        next unless enum in Schematics::Attributes::StateMachine

        enum.events.each do |event|
          Translation.delete_by(locale: available_locales, key: event.i18n_key)
        end
      end
    end
  end

  def rename_model_enums_translations
    return unless renaming?

    PaperTrail.request(enabled: false) do
      entity.enum_attributes.each do |enum|
        enum.values.each do |value|
          Translation
            .where(key: "activerecord.enums.#{old_name}.#{enum.name}.#{value}")
            .update_all(key: "activerecord.enums.#{entity.name}.#{enum.name}.#{value}") # rubocop:disable Rails/SkipsModelValidations
        end
        next unless enum in Schematics::Attributes::StateMachine

        enum.events.each do |event|
          Translation
            .where(key: "activerecord.events.#{old_name}.#{event}")
            .update_all(key: event.i18n_key) # rubocop:disable Rails/SkipsModelValidations
        end
      end
    end
  end

  private

  def entity = Tenant
    .schema
    .find_entity_by_name(name.underscore)

  def old_name = options[:rename]

  def generating?
    behavior == :invoke && !old_name
  end

  def destroying?
    behavior == :revoke
  end

  def renaming?
    behavior == :invoke && old_name
  end

  # :reek:FeatureEnvy
  def translate(text, locale:)
    EasyTranslate.translate(text.humanize, to: locale)
  rescue EasyTranslate::EasyTranslateException
    text.humanize
  end
end
