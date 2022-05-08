# frozen_string_literal: true

module Schematics
  module Attributes
    class String < Text
      include Behaviours::Listable

      def database_type = 'string'
      def icon = :align_justify

      def validators
        super.merge(
          length: {
            minimum: options.min,
            maximum: options.limit,
            is: options.length
          }
        )
      end

      protected

      def migration_options
        super.concat %i[limit]
      end
    end
  end
end
