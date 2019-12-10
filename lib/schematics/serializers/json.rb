module Schematics
  module Serializers
    class JSON < Serializer
      def serialize(records)
        fields = (attributes - references).map(&:render)
        methods = virtuals.map(&:render)
        includes = references.map { |reference| reference.render(@schema.find_descriptor_by_reference(reference.renderable)) }
        unless records.is_a?(Enumerable)
          includes += includes(@entity.has_one_through_associations) 
          includes += includes(@entity.has_many_associations) 
          includes += includes(@entity.has_many_through_associations)
        else
          eager_loading(records, includes)
        end
        records.as_json only: [:id] + fields, methods: methods, include: includes.to_h
      end

      def includes(associations)
        associations.map do |association|
          descriptor = association.entity.descriptor.name.to_sym
          [association.name.to_sym, { only: [:id, descriptor], methods: [descriptor] }]
        end
      end

      def eager_loading(records, includes)
        records = records.includes(includes.to_h.keys) unless includes.empty?
      end
    end
  end
end
