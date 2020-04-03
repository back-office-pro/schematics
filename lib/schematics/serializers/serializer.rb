module Schematics
  module Serializers
    class Serializer
      delegate :virtuals,
               :references,
               :has_one_associations, 
               :has_one_through_associations,
               :has_many_associations, 
               :has_many_through_associations,
               to: :@entity

      def initialize(schema, entity)
        @schema = schema
        @entity = entity
      end

      def serialize(records)
        eager_loading(records) if records.is_a?(Enumerable)
      end

      protected

      def eager_loading(records)
        unless @entity.references.empty?
          records.includes(@entity.references.map(&:name).map(&:to_sym))
        end
      end

      def attributes
        @entity.attributes.select(&:visible?) - @entity.references
      end
    end
  end
end
