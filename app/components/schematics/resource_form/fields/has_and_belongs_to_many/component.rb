# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module HasAndBelongsToMany
        class Component < BelongsTo::Component
          delegate :options, to: :field, private: true
          delegate :group_by, to: :options, private: true

          def collection
            return super unless group_by

            model_class
              .all
              .group_by(&:"#{group_by}_formatted")
              .to_h
              .transform_values { |value| value.map { [_1.to_s, _1.id] } }
              .transform_values(&:sort)
              .sort
          end

          def label = attribute_name
            .humanize
            .pluralize

          def attribute_name = super.singularize
        end
      end
    end
  end
end
