# frozen_string_literal: true

module Schematics
  module Button
    module Import
      class Component < ApplicationComponent
        delegate :human_name_plural, to: :@model_class

        def initialize(model_class:)
          super
          @model_class = model_class
        end

        def render?
          can?(:import, @model_class)
        end
      end
    end
  end
end
