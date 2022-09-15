# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Button
      module AddDropdown
        class Component < ApplicationComponent
          delegate :index, to: :@builder

          def initialize(builder:)
            super
            @builder = builder
          end

          def collection = (Attributes.constants - SchemaEditor::Component::DENYLIST)
            .excluding(Attributes::BelongsTo)
            .map(&Attributes.method(:const_get))
            .sort_by { _1.model_name.human }

          def title = t('.title')
        end
      end
    end
  end
end
