module Schematics
  module Associations
    class HasManyThrough < AssociationThrough
      def name
        super.pluralize
      end
      
      def filter_scope
        nil
      end

      def sort_scope
        nil
      end

      def has_filter_scope
        nil
      end

      def has_sort_scope
        nil
      end
    end
  end
end
