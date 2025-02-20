# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module ModelField
        class Component < Fields::Component
          delegate :collection, :depends_on, to: :field, private: true

          def prompt = t('prompt', attribute_name: attribute_name.downcase)

          def data = {
            controller: 'dropdown',
            'dropdown-depends-on': "#{resource.class.entity.name}[#{depends_on}]"
          }
        end
      end
    end
  end
end
