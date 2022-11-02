# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'active_model_serializers'

module Schematics
  module Entities
    # :reek:Attribute :reek:InstanceVariableAssumption
    class Descriptor
      include ::ActiveModel::API

      validates :field_name, allow_nil: true, inclusion: { in: :allowed_field_names }

      delegate :name, :entity, :to_sql, to: :field
      attr_accessor :entity
      attr_writer :field_name

      def field_name
        @field_name || 'id'
      end

      def joins
        field.try(:preload) || []
      end

      def to_str = <<~RUBY
        def to_s
          #{name}_formatted || id
        end
      RUBY

      def serializer_class
        descriptor = name
        case entity
        when Singleton # rubocop:disable Lint/ConstantResolution
          Class.new(::ActiveModel::Serializer) do
            attribute descriptor
          end
        when Entity
          Class.new(::ActiveModel::Serializer) do
            attribute :id
            attribute descriptor if descriptor != 'id'
          end
        end
      end

      def allowed_field_names = entity
        .fields
        .map(&:name)
        .push('id')
        .sort

      private

      def field
        entity.find_field_by_name(field_name)
      end
    end
  end
end
