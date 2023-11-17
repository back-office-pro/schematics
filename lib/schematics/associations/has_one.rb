# frozen_string_literal: true

require 'active_support/core_ext/string/indent'

module Schematics
  module Associations
    class HasOne < Association
      include Behaviours::Searchable

      def open_api_type = super.first

      def search_data = super
        .concat(' ')
        .concat <<~RUBY
          #{name}&.to_s
        RUBY

      def search_column = :"#{name}_#{descriptor.name}"

      protected

      def association_to_str = super
        .concat(",\n")
        .concat <<~RUBY.indent(8)
          inverse_of: :#{inverse_of},
          autosave: true
        RUBY

      def spec_interpolations = super.merge(entity_name: inverse_of)
    end
  end
end
