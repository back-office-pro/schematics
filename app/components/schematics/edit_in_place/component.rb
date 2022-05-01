# frozen_string_literal: true

module Schematics
  module EditInPlace
    class Component < ApplicationComponent
      def initialize(resource:, field:)
        super
        @resource = resource
        @field = field
      end

      def frame_id
        dom_id(@resource, @field.name)
      end
    end
  end
end
