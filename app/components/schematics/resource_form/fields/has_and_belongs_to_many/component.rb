# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module HasAndBelongsToMany
        class Component < BelongsTo::Component
          delegate :group_by, :filter_by, to: :field, private: true

          memoize def collection
            return super unless group_by

            model_class
              .preload_all
              .all
              .select(&filter_by)
              .group_by(&group_by)
              .to_h
              .transform_values { |value| value.map { [it.to_s, it.id] } }
              .transform_values(&:sort)
              .sort
          end

          def label = resource
            .class
            .human_attribute_name(name, count: 2)

          def control_class
            return %w[form-select] unless inline?

            %w[form-select bg-transparent]
          end

          protected

          def attribute_name = super.singularize(I18n.locale)
        end
      end
    end
  end
end
