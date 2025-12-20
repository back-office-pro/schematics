# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Translations
    class Translate
      include Interactor

      delegate :gcloud_private_api_key, to: '::Configuration', private: true
      delegate :translate, to: :client, private: true
      delegate :text, :locale, to: :context, private: true
      delegate :t, to: '::I18n', private: true

      def call
        context.value = translate(text.humanize, to: locale).text
        context.gender = t(gender, scope:, locale:)
      rescue StandardError
        context.value = text.humanize
        context.gender = t(:default, scope:, locale:)
      end

      private

      memoize def client = ::Google::Cloud::Translate::V2.new(key: gcloud_private_api_key)

      def gender
        return :f if female?

        :m
      end

      def female? = context
        .value
        .downcase
        .start_with?(female_pronoun)

      def female_pronoun = t(:female_pronoun, scope:, locale:)

      def scope = %i[i18n inflections gender]
    end
  end
end
