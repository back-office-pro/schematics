# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Trigger
      class Component < ApplicationComponent
        prepend ViewComponent::GlobalOutputBuffer
        delegate :action, :callback, to: :@trigger
        with_collection_parameter :trigger

        def initialize(trigger:, entity_fields:, entity:)
          super
          @trigger = trigger
          @entity_fields = entity_fields
          @entity = entity
        end
      end
    end
  end
end
