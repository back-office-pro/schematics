# frozen_string_literal: true

module Schematics
  module Button
    module Delete
      class Component < ApplicationComponent
        delegate :can?, to: :helpers

        def initialize(resource:, compact: true)
          super
          @resource = resource
          @compact = compact
        end

        def render?
          can?(:delete, @resource)
        end

        def css_classes
          [
            'btn',
            'btn-danger',
            'btn-sm',
            ('btn-icon-split' unless compact?),
            ('ml-2' unless compact?)
          ].compact
        end

        def compact?
          @compact
        end
      end
    end
  end
end
