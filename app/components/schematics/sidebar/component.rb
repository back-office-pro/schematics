# frozen_string_literal: true

module Schematics
  module Sidebar
    class Component < ApplicationComponent
      def data = {
        controller: 'tooltip hotkey',
        'bs-toggle': 'tooltip',
        'bs-placement': 'bottom',
        'bs-container': '.sidebar'
      }

      def entities = Schema
        .instance
        .entities
        .reject(&:hidden?)
        .select { can?(:index, _1.model_class) }
        .sort_by { _1.model_class.human_name }

      def toggled?
        preferences(:sidebar_toggled, false)
      end
    end
  end
end
