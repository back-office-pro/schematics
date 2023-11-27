# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module HasAndBelongsToMany
        class Component < BelongsTo::Component
          delegate :group_by, :filter_by, to: :options, private: true

          memoize def collection # rubocop:disable Metrics/CyclomaticComplexity
            return super unless group_by

            model_class
              .preload_all
              .all
              .accessible_by(current_ability)
              .select(&(filter_by&.to_sym || :itself))
              .group_by(&:"#{group_by}_formatted")
              .to_h
              .transform_values { |value| value.map { [_1.to_s, _1.id] } }
              .transform_values(&:sort)
              .sort
          end

          def label = super.pluralize

          protected

          def attribute_name = super.singularize
        end
      end
    end
  end
end
