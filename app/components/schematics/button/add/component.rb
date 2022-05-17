# frozen_string_literal: true

module Schematics
  module Button
    module Add
      class Component < ApplicationComponent
        delegate :human_name, :gender, to: :@model_class

        def initialize(model_class:)
          super
          @model_class = model_class
        end

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split ms-2]

        def render?
          can?(:new, @model_class)
        end
      end
    end
  end
end
