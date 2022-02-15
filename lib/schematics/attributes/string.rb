# frozen_string_literal: true

require 'active_support/core_ext/securerandom'

module Schematics
  module Attributes
    class String < Attribute
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Editable
      include Behaviours::Listable

      def type
        'string'
      end

      def search_data
        <<~RUBY
          #{name}&.to_s
        RUBY
      end

      def validators
        super.merge(
          {
            length: {
              minimum: options.min,
              maximum: options.limit,
              is: options.length
            }.compact
          }.compact_blank
        )
      end

      def default
        return SecureRandom.base58 if unique?
        return 'MyString' if required?

        super
      end

      def icon
        :font_case
      end

      def format(value)
        value&.to_s
      end

      protected

      def migration_options
        super.concat %i[default]
      end
    end
  end
end
