# frozen_string_literal: true

module Schematics
  module Button
    module Clipboard
      class Component < ApplicationComponent
        option :value

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split]

        def data = {
          controller: 'clipboard',
          action: 'click->clipboard#copy',
          'clipboard-text-value': value,
          'bs-placement': 'right',
          'bs-trigger': 'manual',
          'bs-title': fa_icon(:check, class: 'me-2 text-success') + t('.tooltip'),
          'bs-html': true
        }

        def icon = :clipboard
      end
    end
  end
end
