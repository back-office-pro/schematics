# frozen_string_literal: true

require 'active_support/core_ext/string/indent'

module Schematics
  module Associations
    class HasOne < Association
      include Behaviours::Searchable

      def open_api_type = super.first

      def to_str = super
        .concat(",\n")
        .concat <<~RUBY.indent(8)
          inverse_of: :#{inverse_of},
          autosave: true
        RUBY

      def search_column = :"#{name}_#{descriptor.name}"
    end
  end
end
