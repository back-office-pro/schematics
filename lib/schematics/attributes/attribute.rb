# frozen_string_literal: true

require 'schematics/behaviours/migratable'
require 'schematics/behaviours/validatable'

module Schematics
  module Attributes
    class Attribute
      include Behaviours::Migratable
      include Behaviours::Validatable

      delegate :hidden?, to: :options
      attr_reader :entity, :name, :options

      class << self
        def create(entity, name:, type:, options: {})
          Attributes.const_get(type.camelize.to_sym).new(entity, name, options)
        end

        def created_at(entity)
          create(entity, type: 'date', name: 'created_at')
        end

        def id(entity)
          create(entity, type: 'integer', name: 'id')
        end
      end

      def initialize(entity, name, options)
        @entity = entity
        @name = name
        @options = Entities::OptionsStruct.new(options)
      end

      def to_sql
        [@entity.name.pluralize, @name].join('.')
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
