# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Template
      module Attribute
        module BelongsToHasOne
          class Component < Template::Component
            option :form

            def attribute = Attributes::BelongsTo.new(
              id: 'RANDOM_UUID',
              entity:,
              options: { inverse_association_type: 'has_one' }
            )
          end
        end
      end
    end
  end
end
