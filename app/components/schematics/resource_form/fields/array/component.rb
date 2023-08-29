# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Array
        class Component < Fields::Component
          def prompt = t('prompt', attribute_name:)

          def data = { controller: 'dropdown', 'dropdown-create-value': true }

          def attribute_name = super.singularize
        end
      end
    end
  end
end
