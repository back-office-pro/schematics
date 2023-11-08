# frozen_string_literal: true

module Schematics
  module HotkeysModal
    class Component < ApplicationComponent
      ALPHABET = [*'0'..'9', *'a'..'z']
                 .without('h', 's')
                 .freeze

      def icon = :keyboard

      def title = t('.title')

      def groups = ::Tenant
        .schema
        .entities
        .reject(&:core?)
        .filter_map(&:model_class)
        .push(::Import, ::ActiveStorage::Blob)
        .select { can?(:index, _1) }
        .sort_by(&:human_name)
        .map
        .with_index { |klass, index| [ALPHABET[index], klass.human_name_plural.humanize] }
        .push(['h', t('.home')], ['s', t('.search')])
        .sort_by(&:first)
        .in_groups_of(2, false)
    end
  end
end
