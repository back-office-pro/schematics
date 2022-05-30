# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Attribute
      class Component < ApplicationComponent
        prepend ViewComponent::GlobalOutputBuffer

        DENYLIST = %i[Association Attribute Month StateMachineEvent Week Year].freeze

        def initialize(builder:)
          super
          @builder = builder
        end

        def collection = (Attributes.constants - DENYLIST)
          .map(&Attributes.method(:const_get))
          .map { [_1.model_name.human, _1.to_s.demodulize.underscore] }
          .sort

        def icon
          @builder.object.try(:icon) || :plus
        end
      end
    end
  end
end
