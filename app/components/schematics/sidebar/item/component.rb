# frozen_string_literal: true

module Schematics
  module Sidebar
    module Item
      class Component < ApplicationComponent
        delegate :human_name, :human_name_plural, :entity, to: :@model_class
        delegate :icon, :enum_attributes, to: :entity
        with_collection_parameter :model_class

        def initialize(model_class:)
          super
          @model_class = model_class
        end

        def path = polymorphic_path(@model_class)

        def css_classes = 'nav-link p-0 m-0 text-secondary text-nowrap'

        def title = "#{human_name_plural.humanize} (#{shortcut})"

        def data = {
          controller: 'tooltip hotkey',
          'bs-toggle': 'tooltip',
          'bs-placement': 'bottom',
          'bs-container': '.sidebar',
          'hotkey-shortcut-value': shortcut
        }

        def toggled_class
          'd-md-block' unless toggled?
        end

        private

        def toggled?
          preferences(:sidebar_toggled, false)
        end

        def shortcut = "Control+#{human_name.first}"
      end
    end
  end
end
