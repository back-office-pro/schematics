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
        context.value = translate(text.humanize, to: locale, key: gcloud_api_key_with_fallback)
        context.gender = t(gender, scope:, locale:)
      rescue ::EasyTranslate::EasyTranslateException
        context.value = text.humanize
        context.gender = t(:default, scope:, locale:)
      end

      private

      def scope = %i[i18n inflections gender]

      def gender
        return :f if female?

        :m
      end

      def female_pronoun = t(:female_pronoun, scope:, locale:)

      def female? = context
        .value
        .downcase
        .start_with?(female_pronoun)
    end
  end
end
