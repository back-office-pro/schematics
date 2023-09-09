# frozen_string_literal: true

module Schematics
  module Attributes
    class Array < Attribute
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable

      def database_index_type = :gin

      def database_type = 'string'

      def default = [SecureRandom.base58]

      def icon = :list

      def migration_options = super.merge(array: true)

      def open_api_type = [super]

      def permitted_params = { super => [] }

      def input_name = "#{super}[]"

      def search_predicate = :any

      def search_data = super
        .concat(' ')
        .concat <<~RUBY
          #{name}&.join(',')
        RUBY

      def format(values)
        values&.join(', ')
      end
    end
  end
end
