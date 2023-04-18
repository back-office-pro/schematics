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

      def model_classes = ::Tenant
        .schema
        .entities
        .reject(&:core?)
        .filter_map(&:model_class)
        .push(::Import, ::ActiveStorage::Blob, ::Article)
        .select { can?(:index, _1) }
        .sort_by(&:human_name)

      def toggled?
        preferences(:sidebar_toggled, false)
      end
    end
  end
end
