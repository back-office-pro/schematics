# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Locale < String
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      def format(value)
        value
          &.split('.')
          &.excluding('activerecord', 'models', 'attributes')
          &.map(&:humanize)
          &.join(' / ')
      end

      def icon = :language
    end
  end
end
