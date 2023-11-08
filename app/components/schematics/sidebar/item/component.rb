# frozen_string_literal: true

module Schematics
  module Sidebar
    module Item
      class Component < ApplicationComponent
        ALPHABET = [*'1'..'9', *'a'..'z']
                   .without('h', 's')
                   .freeze

        delegate :human_name, :human_name_plural, :entity, to: :@model_class
        delegate :icon, :enum_attributes, to: :entity
        with_collection_parameter :model_class

        def initialize(model_class:, model_class_counter:)
          super
          @model_class = model_class
          @counter = model_class_counter
        end

        def path = polymorphic_path(@model_class)

        def css_classes = 'nav-link p-0 m-0 text-secondary text-nowrap'

        def title = "#{human_name_plural.humanize} (#{shortcut})"

        def data = {
          controller: 'tooltip hotkey',
          'bs-placement': 'right',
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

        def shortcut = "Control+#{ALPHABET[@counter]}"
      end
    end
  end
end
