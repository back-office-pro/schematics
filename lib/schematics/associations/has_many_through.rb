require 'schematics/associations/association_through'

module Schematics
  module Associations
    class HasManyThrough < AssociationThrough
      def name
        super.pluralize
      end
    end
  end
end
