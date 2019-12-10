module Schematics
  module Serializers
    class Serializer
      def initialize(schema, entity)
        @schema = schema
        @entity = entity
      end
      
      def type
        self.class.name.demodulize.downcase.to_sym
      end

      def attributes
        @entity.attributes.map { |field| field.renderer[type] }.compact.select(&:visible?).sort_by(&:order)
      end

      def virtuals
        @entity.virtuals.map { |field| field.renderer[type] }.compact.select(&:visible?).sort_by(&:order)
      end

      def references
        @entity.references.map { |field| field.renderer[type] }.compact.select(&:visible?).sort_by(&:order)
      end
    end
  end
end
