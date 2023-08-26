# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module HasMany
        class Component < Fields::Component
          delegate :belongs_to, :entity, to: :field, private: true
          delegate :model_class, :fillable_elements, to: :entity, private: true
          delegate :human_name, to: :model_class

          def id = "nested-associations-#{name}"

          def elements = fillable_elements
            .excluding(belongs_to)
            .stable_sort_by(&:weight)
        end
      end
    end
  end
end
