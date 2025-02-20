# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module HotkeysModal
    class Component < ApplicationComponent
      ALPHABET = [*'1'..'9', *'a'..'z']
                 .without('h', 's')
                 .freeze

      def icon = :keyboard

      def title = t('.title')

      def groups = current_schema
        .model_classes
        .push(::Import, ::ActiveStorage::Blob, ::Emailing)
        .select { can?(:index, it) }
        .sort_by(&:human_name)
        .map
        .with_index { |klass, index| [ALPHABET[index], klass.human_name_plural.humanize] }
        .push(['h', t('.home')], ['s', t('.search')])
        .sort_by(&:first)
        .in_groups_of(2, false)
    end
  end
end
