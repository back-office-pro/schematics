# frozen_string_literal: true

class TranslationGenerator < Rails::Generators::NamedBase
  delegate :available_locales, to: 'Schematics::Engine.config.i18n'
  class_option :rename, type: :string

  def generate_model_translation
    return unless generating?

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        Translation.create!(locale:, key:, value: translate(value, locale:))
      end
    end
  end

  def destroy_model_translation
    return unless destroying?

    PaperTrail.request(enabled: false) do
      Translation.destroy_by(locale: available_locales, key:)
    end
  end

  def rename_model_translation
    return unless renaming?

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        Translation
          .where(key: "activerecord.#{old_name}", locale:)
          .update!(key:, value: translate(value, locale:))
      end
    end
  end

  private

  def old_name = options[:rename]

  def key = "activerecord.#{name}"

  def value = name
    .split('.')
    .last

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
