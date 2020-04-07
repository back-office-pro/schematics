module Schematics
  module Serializers
    class Serializer
      delegate_missing_to :@entity

      def initialize(entity)
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
