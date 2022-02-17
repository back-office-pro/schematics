# frozen_string_literal: true

module Schematics
  module Attributes
    class String < Text
      include Behaviours::Listable

      def type
        'string'
      end

      def validators
        super.merge(
          {
            length: {
              minimum: options.min,
              maximum: options.limit,
              is: options.length
            }.compact
          }.compact_blank
        )
      end

      def input_type
        :input
      end

      def icon
        :align_justify
      end

      protected

      def migration_options
        super.concat %i[limit]
      end
    end
  end
end
