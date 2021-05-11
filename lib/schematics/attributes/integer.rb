require 'schematics/attributes/float'

module Schematics
  module Attributes
    class Integer < Float
      def validators
        super.merge(numericality: { only_integer: true })
      end

      protected

      def migration_options
        super.concat %i[limit]
      end
    end
  end
end
