# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module Archive
      class Component < ApplicationComponent
        option :resource

        def data = {
          turbo_method: :delete,
          turbo_frame: '_top',
          controller: 'tooltip',
          action: 'click->application#disableWith'
        }

        def role = 'button'

        def title = t('.title')

        def css_classes = %w[btn btn-danger btn-sm]

        def icon_class = 'fa-fw'

        def render?
          can?(:archive, resource)
        end
      end
    end
  end
end
