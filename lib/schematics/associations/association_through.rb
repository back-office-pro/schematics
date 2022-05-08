# frozen_string_literal: true

require 'active_support/core_ext/string/indent'

module Schematics
  module Associations
    # :reek:Attribute
    class AssociationThrough < Association
      attr_accessor :through

      def type
        super.chomp('_through')
      end

      def to_str
        super
          .concat(",\n")
          .concat <<~RUBY.indent(8)
            through: :#{through.name},
            source: :#{source}
          RUBY
      end
    end
  end
end
