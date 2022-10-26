# frozen_string_literal: true

module Schematics
  module PdfFooter
    class Component < ApplicationComponent
      def style = <<~CSS.squish
        font-family: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", "Noto Sans", "Liberation Sans", Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
        font-size: 9px;
        font-weight: 400;
        color: #{config(:theme_color)};
      CSS
    end
  end
end
