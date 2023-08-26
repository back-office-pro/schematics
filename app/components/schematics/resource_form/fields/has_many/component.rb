# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module HasMany
        class Component < Fields::Component
          delegate :belongs_to, :nested?, :entity, to: :field, private: true
          delegate :model_class, :fillable_elements, to: :entity, private: true
          delegate :human_name, to: :model_class

          def id = "nested-associations-#{name}"

          def elements = fillable_elements
            .grep_v(Schematics::Associations::HasMany)
            .excluding(belongs_to)
            .stable_sort_by(&:weight)

          alias render? nested?
        end
      end
    end
  end
end
