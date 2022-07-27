# frozen_string_literal: true

module Schematics
  module Button
    module Delete
      class Component < ApplicationComponent
        def initialize(resource:, compact: true)
          super
          @resource = resource
          @compact = compact
        end

        def compact? = @compact

        def css_classes = [
          'btn',
          'btn-danger',
          'btn-sm',
          { 'btn-icon-split': !compact? },
          { 'ms-2': !compact? }
        ]

        def render?
          can?(:delete, @resource)
        end
      end
    end
  end
end
