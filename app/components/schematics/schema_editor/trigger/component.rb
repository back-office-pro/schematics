# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Trigger
      class Component < ApplicationComponent
        option :builder

        def collection = Schematics::Trigger::ACTIONS
          .map { [t(it, scope: %i[activemodel attributes schematics/trigger actions]), it] }
          .sort

        def icon = :atom

        def title = t('.title')

        def prompt = t('prompt', attribute_name:)

        def data = {
          controller: 'popover schema-editor--variable-typeahead',
          'bs-trigger': 'hover',
          'bs-content': __schema_editor_trigger_popover,
          'bs-placement': 'bottom',
          'bs-html': true
        }

        private

        def attribute_name = Schematics::Trigger
          .human_attribute_name('action')
          .downcase
      end
    end
  end
end
