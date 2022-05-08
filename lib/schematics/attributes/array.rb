# frozen_string_literal: true

module Schematics
  module Attributes
    class Array < Attribute
      include Behaviours::Fillable

      def open_api_type = [::String]
      def database_type = 'string'
      def default = []
      def icon = :table

      def permitted_params
        { super => [] }
      end

      def options_for_migration
        super.merge(array: true)
      end

      protected

      def migration_options
        super.concat %i[default]
      end
    end
  end
end
