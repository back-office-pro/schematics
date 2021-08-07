# frozen_string_literal: true

module Schematics
  module Attributes
    class Integer < Float
      def validators
        validators = super
        validators[:numericality][:only_integer] = true
        validators
      end

      protected

      def migration_options
        super.concat %i[limit]
      end
    end
  end
end
