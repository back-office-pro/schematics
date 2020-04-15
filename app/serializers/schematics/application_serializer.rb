module Schematics
  class ApplicationSerializer < ActiveModel::Serializer
    delegate :model_class, to: :class
    delegate :entity, to: :model_class

    class << self
      delegate :entity, to: :model_class

      def inherited(subclass)
        super
        subclass.class_eval do
          attribute :id

          (entity.renderable_fields -
            entity.belongs_to_attributes -
            entity.rich_text_attributes -
            entity.attachment_attributes).each do |field|
            attribute field.name.to_sym
          end

          (entity.attachment_attributes + entity.rich_text_attributes).each do |attribute|
            attribute attribute.name.to_sym do
              attribute.format object.send(attribute.name.to_sym)
            end
          end

          entity.belongs_to_attributes.each do |attribute|
            serializer_class = descriptor_serializer_class(attribute.inverse_descriptor.name.to_sym)
            belongs_to attribute.name.to_sym, serializer: serializer_class
          end

          entity.has_one_and_through_associations.each do |association|
            serializer_class = descriptor_serializer_class(association.descriptor.name.to_sym)
            has_one association.name.to_sym, serializer: serializer_class
          end

          entity.has_many_and_through_associations.each do |association|
            serializer_class = descriptor_serializer_class(association.descriptor.name.to_sym)
            has_many association.name.to_sym,
                     serializer: serializer_class,
                     if: -> { should_render_has_many_associations }
          end
        end
      end

      def model_class
        name.chomp('Serializer').constantize
      end

      def descriptor_serializer_class(descriptor)
        Class.new ActiveModel::Serializer do
          attribute :id
          attribute descriptor
        end
      end
    end

    def should_render_has_many_associations
      instance_options[:template].to_sym == :show
    end
  end
end
