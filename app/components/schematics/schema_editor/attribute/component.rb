# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Attribute
      class Component < ApplicationComponent
        prepend ViewComponent::GlobalOutputBuffer
        delegate :name, :type, :icon, :unique?, :required?, to: :@attribute
        delegate :model_class, :descriptor, to: :@entity
        with_collection_parameter :attribute

        def initialize(attribute:, entity_fields:, entity:)
          super
          @attribute = attribute
          @entity_fields = entity_fields
          @entity = entity
        end

        def types
          Attributes
            .constants
            .reject { %i[Association Attribute Month StateMachineEvent Week Year].include?(_1) }
            .map(&Attributes.method(:const_get))
            .map { [_1.model_name.human, _1.to_s.demodulize.underscore] }
            .sort
        end
      end
    end
  end
end
