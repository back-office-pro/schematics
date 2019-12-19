module Schematics
  module Associations
    class HasMany < Association
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

      def to_str
        super + %Q[, dependent: :#{required? ? "destroy" : "nullify"}]
      end
    end
  end
end
