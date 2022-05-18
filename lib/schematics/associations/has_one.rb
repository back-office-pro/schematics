# frozen_string_literal: true

require 'active_support/core_ext/string/indent'

module Schematics
  module Associations
    class HasOne < Association
      include Behaviours::Searchable

      def open_api_type
        super.first
      end

      def to_str = super
        .concat(",\n")
        .concat <<~RUBY.indent(8)
          inverse_of: :#{inverse_of},
          autosave: true
        RUBY

      def search_data = super
        .concat(' ')
        .concat <<~RUBY
          #{name}&.to_s
        RUBY
    end
  end
end
