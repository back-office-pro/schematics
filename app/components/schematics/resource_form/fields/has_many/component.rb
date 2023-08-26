# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module HasMany
        class Component < Fields::Component
          delegate :belongs_to, :nested?, to: :field, private: true

          def id = "nested-associations-#{name}"

          def elements = field
            .entity
            .fillable_elements
            .grep_v(Schematics::Associations::HasMany)
            .excluding(belongs_to)
            .stable_sort_by(&:weight)

          alias render? nested?
        end
      end
    end
  end
end
