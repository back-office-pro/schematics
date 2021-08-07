# frozen_string_literal: true

module Schematics
  module Associations
    class HasManyThrough < AssociationThrough
      def source
        super.pluralize
      end
    end
  end
end
