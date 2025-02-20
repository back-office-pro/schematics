# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    class String < Text
      include Behaviours::Indexable
      include Behaviours::Listable

      def available_options = super.push(
        Options::Unique,
        Options::CaseInsensitive
      )

      def database_type = 'string'

      def translatable_type = 'string'

      def icon = :align_justify
    end
  end
end
