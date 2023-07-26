# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Address
        class Component < Fields::Component
          def collection
            [value].compact
          end

          def prompt = t('prompt', gender: :female, attribute_name:)

          def autocomplete = 'new-address'

          def data = { controller: 'dropdowns--address-autocomplete-dropdown' }
        end
      end
    end
  end
end
