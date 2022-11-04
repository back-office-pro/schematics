# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Virtual
      class Component < ApplicationComponent
        delegate :icon, to: 'builder.object'
        renders_one_form :builder
        option :builder

        def title = t('.title')

        def data = {
          controller: 'popover',
          'bs-toggle': 'popover',
          'bs-trigger': 'hover',
          'bs-content': Popover::Component.new.to_html,
          'bs-placement': 'bottom',
          'bs-html': true
        }
      end
    end
  end
end
