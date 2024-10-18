# frozen_string_literal: true

module Core
  module Translations
    class Translate
      include Interactor

      delegate :gcloud_api_key_with_fallback, to: ::Configuration, private: true
      delegate :translate, to: ::EasyTranslate, private: true
      delegate :text, :locale, to: :context, private: true
      delegate :t, to: ::I18n, private: true

      def call
        context.value = translate(text.humanize, to: locale, key:)
        context.gender = gender
      rescue ::EasyTranslate::EasyTranslateException
        context.value = text.humanize
        context.gender = t('i18n.inflections.gender.default', locale:)
      end

      private

      alias key gcloud_api_key_with_fallback

      def gender
        return t('i18n.inflections.gender.f', locale:) if female?

        t('i18n.inflections.gender.m', locale:)
      end

      def female_pronoun = t('i18n.inflections.gender.female_pronoun', locale:)

      def female? = context
        .value
        .downcase
        .start_with?(female_pronoun)
    end
  end
end
