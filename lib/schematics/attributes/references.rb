require 'schematics/attributes/association'

module Schematics
  module Attributes
    class References < Association
      # by convention, this attribute will always be set to current_user
      def initialize(entity, name, options)
        super entity, name, options.merge(type: 'user')
      end
    end
  end
end
