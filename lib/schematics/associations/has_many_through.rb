# frozen_string_literal: true

require 'schematics/associations/association_through'

module Schematics
  module Associations
    class HasManyThrough < AssociationThrough
      def source
        super.pluralize
      end
    end
  end
end
