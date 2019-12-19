module Schematics
  module Serializers
    class JSON < Serializer
      def serialize(records)
        super(records)
        includes = references + has_one_associations + has_one_through_associations
        includes += has_many_associations + has_many_through_associations unless records.is_a?(Enumerable)
        records.as_json only: [:id] + attributes, methods: virtuals, include: includes.to_h
      end

      protected

      def attributes
        super.map(&:name).map(&:to_sym)
      end

      def virtuals
        super.map(&:name).map(&:to_sym)
      end

      def references
        super.map do |reference|
          descriptor = reference.descriptor.name.to_sym
          [reference.name.to_sym, { only: [:id, descriptor], methods: [descriptor] }]
        end
      end

      def has_one_associations
        super.map(&method(:has_associations))
      end

      def has_one_through_associations
        super.map(&method(:has_associations))
      end

      def has_many_associations
        super.map(&method(:has_associations))
      end

      def has_many_through_associations
        super.map(&method(:has_associations))
      end

      def has_associations(association)
        descriptor = association.descriptor.name.to_sym
        [association.name.to_sym, { only: [:id, descriptor], methods: [descriptor] }]
      end
    end
  end
end
