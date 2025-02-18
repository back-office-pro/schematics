# frozen_string_literal: true

module Schematics
  module Button
    module ResetFilters
      class Component < ApplicationComponent
        DENYLIST = %i[controller action resource locale page limit].freeze
        option :model_class

        def data = {
          controller: 'tooltip',
          'bs-custom-class': 'responsive-button-tooltip-lg'
        }

        def title = t('.text')

        def css_classes = %w[btn btn-danger btn-sm btn-icon-split ms-1]

        def render?
          !params.except(*DENYLIST).empty?
        end
      end
    end
  end
end
