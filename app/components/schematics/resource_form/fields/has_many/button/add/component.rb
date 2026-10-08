# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module HasMany
        module Button
          module Add
            class Component < ApplicationComponent
              delegate :entity, :name, to: :field, private: true
              delegate :model_class, to: :entity, private: true
              delegate :human_name, :gender, to: :model_class

              option :field

              def template_id = "nested-association-#{name}"

              def target_id = "nested-associations-#{name}"

              def render?
                can?(:create, model_class)
              end
            end
          end
        end
      end
    end
  end
end
