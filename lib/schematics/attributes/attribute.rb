# frozen_string_literal: true

require 'schematics/behaviours/migratable'
require 'schematics/behaviours/validatable'
require 'schematics/behaviours/hidden'
require 'schematics/behaviours/readonly'

module Schematics
  module Attributes
    class Attribute
      include Behaviours::Migratable
      include Behaviours::Validatable

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
        @options = options
        extend Behaviours::Hidden if @options[:hidden]
        extend Behaviours::Readonly if @options[:readonly]
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
