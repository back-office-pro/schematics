# frozen_string_literal: true

module Schematics
  module EditInPlace
    class Component < ApplicationComponent
      def initialize(resource:, field:, highlight: nil)
        super
        @resource = resource
        @field = field
        @highlight = highlight
      end

      def frame_id
        dom_id(@resource, @field.name)
      end
    end
  end
end
