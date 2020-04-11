module Schematics
  module Serializers
    class JSON < Serializer
      def serialize
        includes = references + has_one_and_through_associations
        includes += has_many_and_through_associations unless @records.is_a?(Enumerable)
        @records.as_json only: [:id] + attributes_without_references,
                         methods: virtuals,
                         include: includes.to_h
      end

      protected

      def attributes_without_references
        super.select(&:visible?).map(&:name).map(&:to_sym)
      end

      def virtuals
        super.map(&:name).map(&:to_sym)
      end

      def references
        super.map do |reference|
          descriptor = reference.inverse_descriptor.name.to_sym
          [reference.name.to_sym, { only: [:id, descriptor], methods: [descriptor] }]
        end
      end

      def has_one_and_through_associations
        super.map do |association|
          descriptor = association.descriptor.name.to_sym
          [association.name.to_sym, { only: [:id, descriptor], methods: [descriptor] }]
        end
      end

      def has_many_and_through_associations
        super.map do |association|
          descriptor = association.descriptor.name.to_sym
          [association.name.to_sym, { only: [:id, descriptor], methods: [descriptor] }]
        end
      end
    end
  end
end
