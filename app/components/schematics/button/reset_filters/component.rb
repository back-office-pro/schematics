# frozen_string_literal: true

module Schematics
  module Button
    module ResetFilters
      class Component < ApplicationComponent
        DENYLIST = %i[controller action locale page items model_name].freeze
        option :model_class

        def render?
          !params.except(*DENYLIST).empty?
        end
      end
    end
  end
end
