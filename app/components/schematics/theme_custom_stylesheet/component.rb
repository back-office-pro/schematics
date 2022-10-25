# frozen_string_literal: true

module Schematics
  module ThemeCustomStylesheet
    class Component < ApplicationComponent
      delegate :content_security_policy_nonce, to: :helpers

      def theme_color = settings(:theme_color)

      def theme_color_darken = theme_color
        .paint
        .darken(5)
        .to_s

      def theme_color_rgb = theme_color
        .paint
        .to_rgb
        .scan(/\d+/)
        .join(', ')
    end
  end
end
