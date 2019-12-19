module Schematics
  module Serializers
    class Serializer
      def initialize(schema, entity)
        @schema = schema
        @entity = entity
      end

      def serialize(records)
        eager_loading(records) if records.is_a?(Enumerable)
      end
      
      protected
      
      def eager_loading(records)
        records = records.includes(@entity.references.map(&:name).map(&:to_sym)) unless @entity.references.empty?
      end

      def attributes
        @entity.attributes.select(&:visible?) - @entity.references
      end

      def virtuals
        @entity.virtuals
      end

      def references
        @entity.references
      end

      def has_one_associations
        @entity.has_one_associations
      end

      def has_one_through_associations
        @entity.has_one_through_associations
      end

      def has_many_associations
        @entity.has_many_associations
      end

      def has_many_through_associations
        @entity.has_many_through_associations
      end
    end
  end
end
