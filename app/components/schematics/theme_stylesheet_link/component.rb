# frozen_string_literal: true

module Schematics
  module ThemeStylesheetLink
    class Component < ApplicationComponent
      def initialize(theme:)
        super
        @theme = theme
      end

      def disabled?
        return false unless preferences(:theme)

        preferences(:theme) != @theme
      end

      def media
        return 'all' if preferences(:theme)

        "(prefers-color-scheme: #{@theme})"
      end

      def path
        File.join('schematics', 'themes', @theme)
      end
    end
  end
end
