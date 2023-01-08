# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module HasAndBelongsToMany
        class Component < BelongsTo::Component
          def label = super.pluralize

          def attribute_name = super.singularize
        end
      end
    end
  end
end
