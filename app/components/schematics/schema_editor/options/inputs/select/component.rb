# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Inputs
        module Select
          class Component < Inputs::Component
            delegate :controller, :multiple?, :collection, to: :option

            def data = { controller: }

            def selected = object.try(option_name)

            def include_hidden = false

            def include_blank = t('prompt', attribute_name:)

            private

            def attribute_name = Schematics::Options::Wrapper
              .human_attribute_name(option_name)
              .singularize
              .downcase
          end
        end
      end
    end
  end
end
