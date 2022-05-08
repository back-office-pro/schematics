# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Virtual
      class Component < ApplicationComponent
        prepend ViewComponent::GlobalOutputBuffer
        delegate :name, :icon, :function, to: :@virtual
        delegate :model_class, :descriptor, to: :@entity
        with_collection_parameter :virtual

        def initialize(virtual:, entity_fields:, entity:)
          super
          @virtual = virtual
          @entity_fields = entity_fields
          @entity = entity
        end
      end
    end
  end
end
