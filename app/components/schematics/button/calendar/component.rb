# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module Calendar
      class Component < ApplicationComponent
        delegate :class, to: :resource, prefix: :model, private: true
        delegate :entity, to: :model_class, private: true
        use_helpers :viewers
        option :resource

        def data = {
          controller: 'tooltip',
          'bs-custom-class': 'responsive-button-tooltip-xxl'
        }

        def title = t('.text')

        def css_classes = %w[btn btn-sm btn-icon-split bg-body-tertiary ms-1]

        def render?
          viewers.include?(:calendar)
        end
      end
    end
  end
end
