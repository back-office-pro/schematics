# frozen_string_literal: true

module Schematics
  module Layout
    class Component < ApplicationComponent
      def css_class
        'toggled' if toggled?
      end

      def toggled?
        preferences(:sidebar_toggled, false)
      end
    end
  end
end
