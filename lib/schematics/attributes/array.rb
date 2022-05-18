# frozen_string_literal: true

module Schematics
  module Attributes
    class Array < Attribute
      include Behaviours::Fillable

      def default = []

      def icon = :table

      def open_api_type = [::String]

      def options_for_migration = super.merge(
        array: true
      )

      def permitted_params = {
        super => []
      }

      def type = 'string'

      protected

      def migration_options = super.push(
        :default
      )
    end
  end
end
