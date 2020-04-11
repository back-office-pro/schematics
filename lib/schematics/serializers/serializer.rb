module Schematics
  module Serializers
    class Serializer
      delegate_missing_to :@entity
      delegate :model, to: :@records

      def initialize(entity, records)
        @entity = entity
        @records = records
        eager_loading if enumerable?
      end

      protected

      def enumerable?
        @records.is_a?(Enumerable)
      end

      def eager_loading
        unless @entity.references.empty?
          @records.includes(@entity.references.map(&:name).map(&:to_sym))
        end
      end
    end
  end
end
