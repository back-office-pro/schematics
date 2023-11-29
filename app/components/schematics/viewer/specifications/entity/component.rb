# frozen_string_literal: true

module Schematics
  module Viewer
    module Specifications
      module Entity
        class Component < ApplicationComponent
          delegate :triggers, to: :@entity
          with_collection_parameter :entity

          def initialize(entity:)
            super
            @entity = entity
          end

          def fields = @entity
            .fields
            .sort_by(&:weight)

          def associations = @entity
            .associations
            .reject(&:polymorphic?)
        end
      end
    end
  end
end
