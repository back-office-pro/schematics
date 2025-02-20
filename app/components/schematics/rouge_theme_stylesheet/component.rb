# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module RougeThemeStylesheet
    class Component < ApplicationComponent
      def theme = ::Rouge::Themes::Base16

      def scope = 'pre'
    end
  end
end
