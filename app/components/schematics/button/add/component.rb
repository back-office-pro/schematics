# frozen_string_literal: true

module Schematics
  module Button
    module Add
      class Component < ApplicationComponent
        delegate :can?, to: :helpers

        def initialize(model_class:)
          super
          @model_class = model_class
        end

        def render?
          can?(:create, @model_class)
        end

        def model_name
          @model_class
            .model_name
            .human
            .downcase
        end
      end
    end
  end
end
