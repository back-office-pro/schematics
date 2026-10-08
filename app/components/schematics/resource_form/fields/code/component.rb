# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Code
        class Component < Fields::Component
          delegate :translated?, :language, :readonly?, to: :field

          def wrapper_class = false # rubocop:disable Naming/PredicateMethod

          def wrapper_data = {
            controller: 'code-editor',
            'code-editor-initial-value-value': value,
            'code-editor-language-value': language,
            'code-editor-readonly-value': readonly?
          }

          def data = { 'code-editor-target': 'input' }

          def control_class = 'trix-editor-hidden-input'
        end
      end
    end
  end
end
