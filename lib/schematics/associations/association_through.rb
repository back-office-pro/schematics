# frozen_string_literal: true

require 'active_support/core_ext/string/indent'

module Schematics
  module Associations
    # :reek:Attribute
    class AssociationThrough < Association
      attr_accessor :through

      def type = super.chomp('_through')

      protected

      def prefixed? = entity
        .associations
        .excluding(self)
        .any? { _1.original_name == original_name }

      def association_to_str = super
        .concat(",\n")
        .concat <<~RUBY.indent(8)
          through: :#{through.name},
          source: :#{name}
        RUBY

      def spec_interpolations = super.merge(through: through.name)
    end
  end
end
