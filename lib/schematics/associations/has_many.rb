# frozen_string_literal: true

module Schematics
  module Associations
    class HasMany < Association
      def source
        super.pluralize
      end

      def to_str
        super
          .chomp
          .concat(', ')
          .concat <<~RUBY
            inverse_of: :#{inverse_of},
            dependent: :#{dependent}
          RUBY
      end

      private

      def dependent
        return :destroy if required?

        :nullify
      end
    end
  end
end
