# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module BelongsTo
        class Component < Fields::Component
          delegate :column_name, :model_class, :descriptor, to: :field
          delegate :gender, to: :model_class, private: true

          memoize def collection = model_class
            .preload_all
            .order(created_at: :desc)
            .limit(Loadable::ASSOCIATIONS_LIMIT)
            .to_a
            .union(Array(value))
            .compact
            .map { [it.to_s, it.id] }
            .sort

          def prompt = t('prompt', gender:, attribute_name: attribute_name.downcase)

          def data = {
            controller: 'dropdowns--association-dropdown',
            'dropdowns--association-dropdown-field-value': descriptor.name,
            'dropdowns--association-dropdown-url-value': url
          }

          alias label attribute_name

          protected

          def url = resources_path(model_class, format: :json)
        end
      end
    end
  end
end
