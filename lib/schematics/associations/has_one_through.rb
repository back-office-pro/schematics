# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

module Schematics
  module Associations
    class HasOneThrough < AssociationThrough
      include Behaviours::Searchable

      delegate :descriptor, to: :belongs_to

      def open_api_type
        'integer'
      end

      def source
        belongs_to.name
      end

      def inverse_of
        through.name
      end

      def class_name
        source.camelize
      end

      def to_str
        super
          .chomp
          .concat(",\n")
          .concat <<~RUBY.indent(8)
            autosave: true
          RUBY
      end

      def search_data
        super
          .concat(' ')
          .concat <<~RUBY
            #{name}&.to_s
          RUBY
      end
    end
  end
end
