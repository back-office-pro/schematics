# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Trigger
      class Component < ApplicationComponent
        prepend ViewComponent::GlobalOutputBuffer

        delegate :action, :callback, to: :@trigger
        with_collection_parameter :trigger

        def initialize(trigger:, entities_form:, entity:)
          super
          @trigger = trigger
          @entities_form = entities_form
          @entity = entity
        end

        def collection
          Schematics::Trigger::ACTIONS
        end
      end
    end
  end
end
