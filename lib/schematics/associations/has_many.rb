# frozen_string_literal: true

require 'active_support/core_ext/string/indent'

module Schematics
  module Associations
    class HasMany < Association
      def type = 'has_many'

      def source = super.pluralize

      protected

      def association_to_str = super
        .concat(",\n")
        .concat <<~RUBY.indent(8)
          inverse_of: :#{inverse_of},
          dependent: :#{dependent}
        RUBY

      def dependent
        return :destroy if required?

        :nullify
      end

      def spec_interpolations = super.merge(entity_name: inverse_of)
    end
  end
end
