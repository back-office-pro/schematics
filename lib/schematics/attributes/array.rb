# frozen_string_literal: true

module Schematics
  module Attributes
    class Array < Attribute
      include Behaviours::Migratable
      include Behaviours::Indexable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable

      def database_index_type = :gin

      def database_type = 'json'

      def default = [SecureRandom.base58]

      def icon = :list

      def open_api_schema_type = [super]

      def open_api_query_type = super.first

      def permitted_params = { super => [] }

      def input_name = "#{super}[]"

      def search_predicate = :any

      def format(values)
        values&.join(', ')
      end
    end
  end
end
