# frozen_string_literal: true

module Schematics
  module Button
    module ResetFilters
      class Component < ApplicationComponent
        DENYLIST = %i[controller action locale page items model_name].freeze

        def initialize(model_class:)
          super
          @model_class = model_class
        end

        def render?
          !params.except(*DENYLIST).empty?
        end
      end
    end
  end
end
