# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Virtual
      class Component < ApplicationComponent
        delegate :icon, to: 'builder.object'
        option :builder

        def title = t('.title')

        def data = {
          controller: 'popover schema-editor--variable-typeahead',
          'bs-trigger': 'hover',
          'bs-content': __schema_editor_virtual_popover,
          'bs-placement': 'bottom',
          'bs-html': true
        }
      end
    end
  end
end
