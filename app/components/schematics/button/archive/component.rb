# frozen_string_literal: true

module Schematics
  module Button
    module Archive
      class Component < ApplicationComponent
        def initialize(resource:)
          super
          @resource = resource
        end

        def data
          {
            turbo_method: :delete,
            turbo_frame: '_top',
            controller: 'tooltip',
            'bs-toggle': 'tooltip',
            'bs-placement': 'top'
          }
        end

        def render?
          can?(:archive, @resource)
        end
      end
    end
  end
end
