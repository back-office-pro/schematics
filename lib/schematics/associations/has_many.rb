module Schematics
  module Associations
    class HasMany < Association
      def name
        super.pluralize
      end

      def to_str
        super.squish + ', ' + <<~RUBY
          dependent: :#{dependent_method}
        RUBY
      end

      private

      def dependent_method
        required? ? :destroy : :nullify
      end
    end
  end
end
