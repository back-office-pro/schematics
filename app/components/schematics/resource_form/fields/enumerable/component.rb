# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Enumerable
        class Component < Fields::Component
          delegate :collection, to: :field

          def prompt = t('prompt', attribute_name: attribute_name.downcase)

          def data = { controller: 'schema-editor--modal-dropdown' }
        end
      end
    end
  end
end
