# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module Emailing
      class Component < ApplicationComponent
        delegate :icon, to: 'current_module::Emailing.entity'
        option :resource

        def data = {
          turbo_frame: '_top',
          controller: 'tooltip',
          'bs-custom-class': 'responsive-button-tooltip-xxl'
        }

        def title = t('.text')

        def css_classes = %w[btn btn-sm btn-icon-split bg-body-tertiary ms-1]

        def path = new_emailing_resource_path(resource)

        def render?
          can?(:email, resource)
        end
      end
    end
  end
end
