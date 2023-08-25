# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Button
      module Add
        class Component < ApplicationComponent
          delegate :entity, to: :field, private: true
          delegate :model_class, to: :entity, private: true
          delegate :human_name, :gender, to: :model_class

          option :field

          def render?
            can?(:create, model_class)
          end
        end
      end
    end
  end
end
