# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Translations
    class LookupQuery < Schematics::ApplicationQuery
      def call(locale, key)
        where(locale:)
          .where(arel_table[:key].matches("#{key}.%"))
          .or(where(locale:, key:))
          .pluck(:key, :value)
          .to_h
      end
    end
  end
end
