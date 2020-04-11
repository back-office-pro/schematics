module Schematics
  module Serializers
    class Serializer
      delegate_missing_to :@entity
      delegate :model, to: :@records

      def initialize(entity, records)
        @entity = entity
        @records = records
      end
    end
  end
end
