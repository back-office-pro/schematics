# frozen_string_literal: true

module Schematics
  module DocumentElement
    class Component < ApplicationComponent
      delegate :preferences_theme, to: :current_user, private: true
      delegate :locale, to: '::I18n'

      def theme
        preferences_theme || preferred_theme
      end

      def css_classes = class_names('dark-mode': theme == 'dark')

      private

      def preferred_theme = request
        .headers
        .fetch('Sec-CH-Prefers-Color-Scheme', 'light')
    end
  end
end
