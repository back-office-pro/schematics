# frozen_string_literal: true

module Schematics
  module Button
    module Confirm
      class Component < ApplicationComponent
        def initialize(compact: false)
          super
          @compact = compact
        end

        def compact? = @compact

        def css_classes
          [
            'btn',
            'btn-primary',
            'btn-sm',
            ('btn-icon-split' unless compact?),
            ('me-2' unless compact?),
            ('mx-1' if compact?)
          ].compact
        end

        def icon_class
          'fa-fw' if compact?
        end
      end
    end
  end
end
