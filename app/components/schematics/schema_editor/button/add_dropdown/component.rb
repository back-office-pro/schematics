# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Button
      module AddDropdown
        class Component < ApplicationComponent
          DENYLIST = %i[Association Attribute Month StateMachineEvent Week Year].freeze
          delegate :index, to: :@builder

          def initialize(builder:)
            super
            @builder = builder
          end

          def collection = (Attributes.constants - DENYLIST)
            .map(&Attributes.method(:const_get))
            .sort_by { _1.model_name.human }
        end
      end
    end
  end
end
