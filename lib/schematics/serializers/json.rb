module Schematics
  module Serializers
    class JSON < Serializer
      def serialize
        includes = belongs_to_attributes +
          attachment_attributes +
          rich_text_attributes +
          has_one_and_through_associations
        includes += has_many_and_through_associations unless @records.is_a?(Enumerable)
        Array.wrap(@records).map do |record|
          remove_nil_attachments(record, includes)
          record.as_json only: [:id] + attributes,
                         methods: virtuals,
                         include: includes.to_h
        end
      end

      protected

      def attributes
        (super - belongs_to_attributes - attachment_attributes - rich_text_attributes).
          select(&:visible?).map(&:name).map(&:to_sym)
      end

      def virtuals
        super.map(&:name).map(&:to_sym)
      end

      def attachment_attributes
        super.map do |attribute|
          [attribute.name.to_sym, { only: [], methods: [:filename] }]
        end
      end

      def rich_text_attributes
        super.map do |attribute|
          [attribute.name.to_sym, { only: [], methods: [:to_plain_text] }]
        end
      end

      def belongs_to_attributes
        super.map do |attribute|
          descriptor = attribute.inverse_descriptor.name.to_sym
          [attribute.name.to_sym, { only: [:id, descriptor], methods: [descriptor] }]
        end
      end

      def remove_nil_attachments(record, includes)
        attachment_attributes.reject { |attachment| record.send(attachment.first).attached? }.
          each do |attachment|
          includes.delete(attachment)
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
