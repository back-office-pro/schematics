# frozen_string_literal: true

module Schematics
  module Button
    module Alert
      class Component < ApplicationComponent
        delegate :icon, to: '::Alert.entity'
        option :resource

        def data = {
          turbo_frame: '_top',
          controller: 'tooltip',
          'bs-custom-class': 'responsive-button-tooltip-xxl'
        }

        def title = t('.text')

        def css_classes = %w[btn btn-danger btn-sm btn-icon-split ms-1]

        def path = new_polymorphic_path([resource, ::Alert], format: nil)

        def render?
          can?(:alert, resource)
        end
      end
    end
  end
end
