# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Template
      class Component < ApplicationComponent
        option :form
        option :attribute

        def model = attribute
          .entity
          .model_class
          .new

        def elements = attribute
          .entity
          .fillable_elements
          .excluding(attribute)
          .stable_sort_by(&:weight)
      end
    end
  end
end
