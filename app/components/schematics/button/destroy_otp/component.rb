# frozen_string_literal: true

module Schematics
  module Button
    module DestroyOTP
      class Component < ApplicationComponent
        def data = {
          controller: 'tooltip',
          'bs-custom-class': 'responsive-button-tooltip-lg'
        }

        def title = t('.text')

        def css_classes = %w[btn btn-danger btn-sm btn-icon-split]

        def form = { class: 'd-inline' }
      end
    end
  end
end
