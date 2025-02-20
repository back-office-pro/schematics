# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    class Array < Jsonb
      include Behaviours::Searchable
      include Behaviours::Encryptable

      def database_type = 'jsonb'

      def default = [SecureRandom.base58]

      def icon = :list

      def open_api_schema_type = %w[string]

      def open_api_query_type = super.first

      def permitted_params = { super.first.first => [] }

      def input_name = "#{super}[]"

      def search_predicate = :any

      def format(values)
        values&.join(', ')
      end
    end
  end
end
