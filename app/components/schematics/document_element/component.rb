# frozen_string_literal: true

module Schematics
  module DocumentElement
    class Component < ApplicationComponent
      delegate :locale, to: ::I18n

      def theme = preferences(:theme, preferred_theme)

      private

      def preferred_theme = request
        .headers
        .fetch('Sec-CH-Prefers-Color-Scheme', 'light')
    end
  end
end
