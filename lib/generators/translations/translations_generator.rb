# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

class TranslationsGenerator < Rails::Generators::NamedBase # rubocop:disable Metrics/ClassLength
  delegate :available_locales, to: 'I18n'
  class_option :rename, type: :string

  def generate_model_gender_translations
    return unless generating?

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        Translation.create!(
          locale:,
          key: "activerecord.models.#{name}.gender",
          value: translate("one #{name}", locale:, key: :gender)
        )
      end
    end
  end

  def destroy_model_gender_translations
    return unless destroying?

    PaperTrail.request(enabled: false) do
      Translation.delete_by(
        locale: available_locales,
        key: "activerecord.models.#{name}.gender"
      )
    end
  end

  def rename_model_gender_translations
    return unless renaming?

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        Translation
          .where(key: "activerecord.models.#{old_name}.gender", locale:)
          .update!(key: "activerecord.models.#{name}.gender")
      end
    end
  end

  def generate_model_singular_translations
    return unless generating?

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        Translation.create!(
          locale:,
          key: "activerecord.models.#{name}.one",
          value: translate(name, locale:)
        )
      end
    end
  end

  def destroy_model_singular_translations
    return unless destroying?

    PaperTrail.request(enabled: false) do
      Translation.delete_by(
        locale: available_locales,
        key: "activerecord.models.#{name}.one"
      )
    end
  end

  def rename_model_singular_translations
    return unless renaming?

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        Translation
          .where(key: "activerecord.models.#{old_name}.one", locale:)
          .update!(
            key: "activerecord.models.#{name}.one",
            value: translate(name, locale:)
          )
      end
    end
  end

  def generate_model_plural_translations
    return unless generating?

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        Translation.create!(
          locale:,
          key: "activerecord.models.#{name}.other",
          value: translate(name.pluralize, locale:)
        )
      end
    end
  end

  def destroy_model_plural_translations
    return unless destroying?

    PaperTrail.request(enabled: false) do
      Translation.delete_by(
        locale: available_locales,
        key: "activerecord.models.#{name}.other"
      )
    end
  end

  def rename_model_plural_translations
    return unless renaming?

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        Translation
          .where(key: "activerecord.models.#{old_name}.other", locale:)
          .update!(
            key: "activerecord.models.#{name}.other",
            value: translate(name.pluralize, locale:)
          )
      end
    end
  end

  private

  def generating?
    behavior == :invoke && !old_name
  end

  def old_name = options[:rename]

  def translate(text, locale:, key: :value)
    Core::Translations::Translate.call(text:, locale:).public_send(key)
  end

  def destroying?
    behavior == :revoke
  end

  def renaming?
    behavior == :invoke && old_name
  end
end
