# frozen_string_literal: true

require 'active_support/core_ext/string/indent'

module Schematics
  module Associations
    class AssociationThrough < Association
      attr_reader :through

      def initialize(belongs_to, through)
        super(belongs_to)
        @through = through
      end

      def type
        super.chomp('_through')
      end

      def to_str
        super
          .chomp
          .concat(",\n")
          .concat <<~RUBY.indent(8)
            through: :#{@through.name},
            source: :#{source}
          RUBY
      end
    end
  end
end
