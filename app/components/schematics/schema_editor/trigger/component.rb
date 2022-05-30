# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Trigger
      class Component < ApplicationComponent
        prepend ViewComponent::GlobalOutputBuffer

        def initialize(builder:)
          super
          @builder = builder
        end

        def collection = Schematics::Trigger::ACTIONS

        def icon = :atom
      end
    end
  end
end
