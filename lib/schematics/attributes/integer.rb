require 'schematics/attributes/float'

module Schematics
  module Attributes
    class Integer < Float
      def validators
        validators = super
        validators[:numericality][:only_integer] = true
        validators
      end
    end
  end
end
