# frozen_string_literal: true

module Schematics
  module Attributes
    class Array < Attribute
      include Behaviours::Fillable

      def type
        'string'
      end

      def permitted_params
        { super => [] }
      end

      def default
        []
      end

      def options_for_migration
        super.merge(array: true)
      end

      def icon
        :table
      end

      protected

      def migration_options
        super.concat %i[default]
      end
    end
  end
end
