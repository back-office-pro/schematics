# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

class TranslationGenerator < Rails::Generators::NamedBase
  delegate :available_locales, to: 'I18n'
  class_option :rename, type: :string

  def generate_model_translation
    return unless generating?

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        Translation.create!(locale:, key: name, value: translate(value, locale:))
      end
    end
  end

  def destroy_model_translation
    return unless destroying?

    PaperTrail.request(enabled: false) do
      Translation.delete_by(locale: available_locales, key: name)
    end
  end

  def rename_model_translation
    return unless renaming?

    PaperTrail.request(enabled: false) do
      available_locales.each do |locale|
        Translation
          .where(key: old_name, locale:)
          .update!(key: name, value: translate(value, locale:))
      end
    end
  end

  private

  def generating?
    behavior == :invoke && !old_name
  end

  def old_name = options[:rename]

  def translate(text, locale:)
    Core::Translations::Translate.call(text:, locale:).value
  end

  def value = name
    .split('.')
    .last

  def destroying?
    behavior == :revoke
  end

  def renaming?
    behavior == :invoke && old_name
  end
end
