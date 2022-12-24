# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

module Schematics
  module Associations
    class HasOneThrough < AssociationThrough
      include Behaviours::Searchable

      delegate :descriptor, to: :belongs_to

      def open_api_type = super.first

      def source = belongs_to.name

      def inverse_of = through.name

      def class_name = source.camelize

      def to_str = super
        .chomp
        .concat(",\n")
        .concat <<~RUBY.indent(8)
          autosave: true
        RUBY

      def search_data = super
        .concat(' ')
        .concat <<~RUBY
          #{name}&.to_s
        RUBY

      def search_column = :"#{name}_#{descriptor.name}"
    end
  end
end
