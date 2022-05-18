# frozen_string_literal: true

module Schematics
  module Button
    module Cancel
      class Component < ApplicationComponent
        def initialize(path: nil, data: nil, compact: false)
          super
          @path = path
          @data = data
          @compact = compact
        end

        def compact? = @compact

        def css_classes = [
          'btn',
          'btn-danger',
          'btn-sm',
          ('btn-icon-split' unless compact?)
        ].compact

        def icon_class
          'fa-fw' if compact?
        end
      end
    end
  end
end
