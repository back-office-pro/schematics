# frozen_string_literal: true

module Schematics
  module Button
    module Revert
      class Component < ApplicationComponent
        option :version

        def data = {
          controller: 'tooltip',
          'bs-custom-class': 'responsive-button-tooltip-lg'
        }

        def title = t('.text')

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split]

        def render?
          can?(:revert, version)
        end
      end
    end
  end
end
