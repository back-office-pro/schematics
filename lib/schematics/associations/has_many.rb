module Schematics
  module Associations
    class HasMany < Association
      def name
        super.pluralize
      end

      def to_str
        super.extends_with_comma <<~RUBY
          dependent: :#{required? ? "destroy" : "nullify"}
        RUBY
      end
    end
  end
end
