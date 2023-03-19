# frozen_string_literal: true

module Schematics
  module Sidebar
    class Component < ApplicationComponent
      DENYLIST = [
        ::ApiKey,
        ::Chart,
        ::Message,
        ::Meeting,
        ::Permission,
        ::SchemaDataset,
        ::Stat,
        ::Task,
        ::Translation
      ].freeze

      def data = {
        controller: 'tooltip hotkey',
        'bs-toggle': 'tooltip',
        'bs-placement': 'bottom',
        'bs-container': '.sidebar'
      }

      def model_classes = ::Tenant
        .schema
        .entities
        .reject(&:hidden?)
        .filter_map(&:model_class)
        .excluding(DENYLIST)
        .select { can?(:index, _1) }
        .sort_by(&:human_name)

      def toggled?
        preferences(:sidebar_toggled, false)
      end
    end
  end
end
