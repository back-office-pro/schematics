# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module HasMany
        module Template
          class Component < ApplicationComponent
            delegate :entity, :belongs_to, :name, to: :field, private: true
            delegate :model_class, :fillable_elements, to: :entity, private: true

            option :form
            option :field

            def id = "nested-association-#{name}"

            alias css_class id

            def elements = fillable_elements
              .grep_v(Associations::HasMany)
              .excluding(belongs_to)
              .stable_sort_by(&:weight)
          end
        end
      end
    end
  end
end
