# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Template
      class Component < ApplicationComponent
        delegate :entity, to: :field, private: true
        delegate :model_class, :fillable_elements, to: :entity, private: true

        option :form
        option :field

        def elements = fillable_elements
          .excluding(field)
          .stable_sort_by(&:weight)
      end
    end
  end
end
