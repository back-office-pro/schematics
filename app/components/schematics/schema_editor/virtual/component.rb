# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Virtual
      class Component < ApplicationComponent
        prepend ViewComponent::GlobalOutputBuffer
        delegate :name, :icon, :function, to: :@virtual
        delegate :model_class, to: :@entity
        delegate :human_attribute_name, to: :model_class
        with_collection_parameter :virtual

        def initialize(virtual:, entities_form:, entity:)
          super
          @virtual = virtual
          @entities_form = entities_form
          @entity = entity
        end
      end
    end
  end
end
