# frozen_string_literal: true

module Schematics
  module Viewer
    module Schema
      class Component < ApplicationComponent
        def initialize(schema:)
          super
          @schema = schema
        end

        def entities = @schema
          .entities
          .reject(&:core?)

        def render?
          @schema.present?
        end
      end
    end
  end
end
