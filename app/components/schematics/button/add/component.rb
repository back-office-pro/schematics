# frozen_string_literal: true

module Schematics
  module Button
    module Add
      class Component < ApplicationComponent
        delegate :human_name, :gender, to: :@model_class

        def initialize(model_class:, resource: nil)
          super
          @model_class = model_class
          @resource = resource
        end

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split ms-2]

        def path = new_polymorphic_path([@resource, @model_class].compact)

        def render?
          can?(:new, @model_class)
        end
      end
    end
  end
end
