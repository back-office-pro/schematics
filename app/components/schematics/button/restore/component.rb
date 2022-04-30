# frozen_string_literal: true

module Schematics
  module Button
    module Restore
      class Component < ApplicationComponent
        def initialize(resource:)
          super
          @resource = resource
        end

        def render?
          can?(:restore, @resource)
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
      end
    end
  end
end
