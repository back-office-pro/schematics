# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module HasMany
        module Template
          class Component < ApplicationComponent
            delegate :entity, :belongs_to, :name, to: :field, private: true
            delegate :model_class, :fillable_elements, :icon, to: :entity, private: true
            delegate :human_name, to: :model_class

            option :form
            option :field

            def id = "nested-association-#{name}"

            alias css_class id

            def elements = fillable_elements
              .excluding(belongs_to)
              .stable_sort_by(&:weight)
          end
        end
      end
    end
  end
end
