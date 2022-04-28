# frozen_string_literal: true

module Schematics
  module Attributes
    class Attribute
      include Behaviours::Migratable
      include Behaviours::Validatable

      delegate :hidden?, :cached?, :encrypted?, to: :options
      attr_reader :entity, :name, :options

      class << self
        def build(entity, name:, type:, options: {})
          Attributes.const_get(type.camelize.to_sym).new(entity, name, options)
        end
      end

      def initialize(entity, name, options)
        @entity = entity
        @name = name
        @options = Schematics::Options.new(options)
      end

      def open_api_type
        ::String
      end

      def to_sql
        [@entity.table_name.pluralize, @name].join('.')
      end

      def to_str
        return '' unless encrypted?

        <<~RUBY
          encrypts :#{name}, deterministic: true
        RUBY
      end

      def weight
        1
      end
    end
  end
end
