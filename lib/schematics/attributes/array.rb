# frozen_string_literal: true

module Schematics
  module Attributes
    class Array < Attribute
      include Behaviours::Fillable

      def database_index_type = :gin

      def database_type = 'string'

      def default = []

      def icon = :table

      def migration_options = super.merge(
        array: true
      )

      def open_api_type = [::String]

      def permitted_params = {
        super => []
      }
    end
  end
end
