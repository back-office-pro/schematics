# frozen_string_literal: true

module Schematics
  module Resource
    class Component < ApplicationComponent
      def initialize(resource:, field:, enable_buttons: false, highlight: nil)
        super
        @resource = resource
        @field = field
        @enable_buttons = enable_buttons
        @highlight = highlight
      end

      def enable_buttons? = @enable_buttons

      def value
        @resource.public_send(@field.name)
      end
    end
  end
end
