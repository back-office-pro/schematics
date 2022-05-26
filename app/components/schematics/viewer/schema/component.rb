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
      end
    end
  end
end
