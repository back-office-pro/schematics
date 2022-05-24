# frozen_string_literal: true

module Schematics
  module Placeholder
    class Component < ApplicationComponent
      def initialize(visible: true, size: 16, cols: 1)
        super
        @visible = visible
        @size = size
        @cols = cols
      end

      def col_class = "col-#{12 / @cols}"

      def css_classes
        'd-none' unless visible?
      end

      def visible? = @visible
    end
  end
end
