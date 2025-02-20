# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module PDFHeader
    class Component < ApplicationComponent
      delegate :theme_color, :company_name, to: '::Configuration'
      option :resource

      def style = <<~CSS.squish
        font-family: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", "Noto Sans", "Liberation Sans", Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
        font-size: 12px;
        font-weight: 400;
        color: #{theme_color};
      CSS
    end
  end
end
