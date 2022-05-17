# frozen_string_literal: true

module Schematics
  module Placeholder
    class Component < ApplicationComponent
      def initialize(visible: true, size: 16)
        super
        @visible = visible
        @size = size
      end

      def css_classes
        'd-none' unless visible?
      end

      def visible? = @visible
    end
  end
end
