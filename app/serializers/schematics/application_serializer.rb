module Schematics
  class ApplicationSerializer < ActiveModel::Serializer
    delegate :model_class, to: :class, private: true
    delegate :entity, to: :model_class, private: true

    class << self
      delegate :entity, to: :model_class, private: true

      def inherited(subclass)
        super
        subclass.class_eval do
          attribute :id unless entity.is_a?(Entities::Singleton)
          entity.elements.sort_by(&:weight).each do |element|
            case element
            when Attributes::Attachment, Attributes::RichText
              attribute element.name.to_sym do
                element.format object.send(element.name.to_sym)
              end
            when Attributes::Association
              belongs_to element.name.to_sym,
                         serializer: element.inverse_descriptor.serializer_class
            when Associations::HasOne, Associations::HasOneThrough
              has_one element.name.to_sym,
                      serializer: element.descriptor.serializer_class
            when Associations::HasMany,
                 Associations::HasManyThrough,
                 Associations::HasAndBelongsToMany
              has_many element.name.to_sym,
                       serializer: element.descriptor.serializer_class,
                       if: -> { should_render_has_many_associations }
            else
              attribute element.name.to_sym
            end
          end
        end
      end

      def model_class
        name.chomp('Serializer').constantize
      end
    end

    def should_render_has_many_associations
      instance_options[:template]&.to_sym == :show
    end
  end
end
