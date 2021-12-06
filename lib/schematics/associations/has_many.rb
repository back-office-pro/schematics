# frozen_string_literal: true

require 'active_support/core_ext/string/indent'

module Schematics
  module Associations
    class HasMany < Association
      def source
        super.pluralize
      end

      def to_str
        super
          .chomp
          .concat(",\n")
          .concat <<~RUBY.indent(8)
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
