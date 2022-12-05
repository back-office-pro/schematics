# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Trigger
      class Component < ApplicationComponent
        renders_one_form :builder
        option :builder

        def collection = Schematics::Trigger::ACTIONS
          .map { [t(_1, scope: %i[activerecord attributes permission actions]), _1] }
          .sort

        def icon = :atom

        def title = t('.title')

        def data = {
          controller: 'popover schema-editor--variable-typeahead',
          'bs-toggle': 'popover',
          'bs-trigger': 'hover',
          'bs-content': Popover::Component.new.to_html,
          'bs-placement': 'bottom',
          'bs-html': true
        }

        def wrapper = :input_group
      end
    end
  end
end
