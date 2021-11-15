# frozen_string_literal: true

module Schematics
  module Attributes
    class Attribute
      include Behaviours::Migratable
      include Behaviours::Validatable

      delegate :hidden?, :cached?, to: :options
      attr_reader :entity, :name, :options

      class << self
        def create(entity, name:, type:, options: {})
          Attributes.const_get(type.camelize.to_sym).new(entity, name, options)
        end
      end

      def initialize(entity, name, options)
        @entity = entity
        @name = name
        @options = Options.new(options)
      end

      def to_sql
        [@entity.table_name.pluralize, @name].join('.')
      end

      def to_str
        ''
      end

      def weight
        1
      end
    end
  end
end
