# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Attribute
      class Component < ApplicationComponent
        prepend ViewComponent::GlobalOutputBuffer

        DENYLIST = %i[Association Attribute Month StateMachineEvent Week Year].freeze

        delegate :name, :type, :icon, :options, to: :@attribute
        delegate :model_class, to: :@entity
        delegate :human_attribute_name, to: :model_class
        with_collection_parameter :attribute

        def initialize(attribute:, entities_form:, entity:)
          super
          @attribute = attribute
          @entities_form = entities_form
          @entity = entity
        end

        def types = (Attributes.constants - DENYLIST)
          .map(&Attributes.method(:const_get))
          .map { [_1.model_name.human, _1.to_s.demodulize.underscore] }
          .sort
      end
    end
  end
end
