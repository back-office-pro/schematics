# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module ThemeCustomStylesheet
    class Component < ApplicationComponent
      delegate :theme_color, to: 'current_module::Configuration'

      def theme_color_darken = theme_color
        .paint
        .darken(12)
        .to_s

      def theme_color_darken_rgb = theme_color_darken
        .paint
        .to_rgb
        .scan(/\d+/)
        .join(', ')

      def theme_color_rgb = theme_color
        .paint
        .to_rgb
        .scan(/\d+/)
        .join(', ')
    end
  end
end
