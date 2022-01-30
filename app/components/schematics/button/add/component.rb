# frozen_string_literal: true

module Schematics
  module Button
    module Add
      class Component < ApplicationComponent
        delegate :can?, to: :helpers
        delegate :human_name, :gender, to: :@model_class

        def initialize(model_class:)
          super
          @model_class = model_class
        end

        def render?
          can?(:create, @model_class)
        end
      end
    end
  end
end
