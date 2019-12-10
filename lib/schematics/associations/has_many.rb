module Schematics
  module Associations
    class HasMany < Association
      def name
        super.pluralize
      end

      def to_str
        super + %Q[, dependent: :#{required? ? "destroy" : "nullify"}]
      end
    end
  end
end
