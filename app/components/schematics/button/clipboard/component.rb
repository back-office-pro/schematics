# frozen_string_literal: true

module Schematics
  module Button
    module Clipboard
      class Component < ApplicationComponent
        def initialize(value:)
          super
          @value = value
        end

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split]

        def data = {
          controller: 'clipboard',
          action: 'click->clipboard#copy',
          'clipboard-text-value': @value
        }

        def icon = :clipboard
      end
    end
  end
end
