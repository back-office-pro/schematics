# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module Duplicate
      class Component < ApplicationComponent
        option :resource

        def data = {
          controller: 'tooltip',
          'bs-custom-class': 'responsive-button-tooltip-xxl'
        }

        def title = t('.text')

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split ms-1]

        def form = { class: 'd-inline' }

        def render?
          can?(:duplicate, resource)
        end
      end
    end
  end
end
