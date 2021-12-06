# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'active_model_serializers'

module Schematics
  module Entities
    class Descriptor
      delegate :name, :entity, :to_sql, to: :@field

      class << self
        def build(entity, descriptor)
          field = entity.find_field_by_name(descriptor)
          new(field)
        end
      end

      def initialize(field)
        @field = field
      end

      def joins
        @field.try(:preload) || []
      end

      def to_str
        <<~RUBY
          alias_attribute :to_s, :#{name}_formatted
        RUBY
      end

      def serializer_class
        descriptor = name
        case entity
        when Singleton
          Class.new ActiveModel::Serializer do
            attribute descriptor
          end
        when Entity
          Class.new ActiveModel::Serializer do
            attribute :id
            attribute descriptor if descriptor != 'id'
          end
        end
      end
    end
  end
end
