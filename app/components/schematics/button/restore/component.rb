# frozen_string_literal: true

module Schematics
  module Button
    module Restore
      class Component < ApplicationComponent
        option :resource

        def data = {
          turbo_method: :delete,
          turbo_frame: '_top',
          controller: 'tooltip',
          'bs-toggle': 'tooltip',
          'bs-placement': 'top'
        }

        def render?
          can?(:restore, resource)
        end
      end
    end
  end
end
