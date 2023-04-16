# frozen_string_literal: true

class TranslationGenerator < Rails::Generators::NamedBase
  delegate :available_locales, to: 'Schematics::Engine.config.i18n'

  class_option :field, type: :string
  class_option :rename, type: :string

  def generate_model_attribute_translation
    return unless generating?

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        Translation.create!(
          locale:,
          key: "activerecord.attributes.#{entity.name}.#{field}",
          value: translate(field, locale:)
        )
      end
    end
  end

  def destroy_model_attribute_translation
    return unless destroying?

    PaperTrail.request(enabled: false) do
      Translation.destroy_by(
        locale: available_locales,
        key: "activerecord.attributes.#{entity.name}.#{field}"
      )
    end
  end

  def rename_model_attribute_translation
    return unless renaming?

    PaperTrail.request(enabled: false) do
      Translation
        .where(key: "activerecord.attributes.#{old_name}.#{field}")
        .update_all(key: "activerecord.attributes.#{entity.name}.#{field}") # rubocop:disable Rails/SkipsModelValidations
    end
  end

  private

  def entity = ::Tenant
    .schema
    .find_entity_by_name(name.underscore)

  def old_name = options[:rename]

  # :reek:NilCheck
  def generating?
    behavior == :invoke && old_name.nil?
  end

  def destroying?
    behavior == :revoke
  end

  def renaming?
    behavior == :invoke && old_name.present?
  end

  # :reek:FeatureEnvy
  def translate(text, locale:)
    EasyTranslate.translate(text.humanize, to: locale)
  rescue EasyTranslate::EasyTranslateException
    text.humanize
  end
end
