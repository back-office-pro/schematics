# frozen_string_literal: true

module Schematics
  module JsonSerializer
    extend ActiveSupport::Concern

    included do
      attribute :id unless entity.is_a?(Entities::Singleton)
      attribute :_metadata, if: :metadata?
      attribute :_mention, if: :mention?
      attribute :attachable_sgid, if: :mention?

      entity.renderable_elements.stable_sort_by(&:weight).each do |element|
        case element
        when Attributes::Attachment, Attributes::RichText
          attribute element.name.to_sym do
            element.format object.public_send(element.name.to_sym)
          end
        when Attributes::Association, Associations::HasOne, Associations::HasOneThrough
          has_one element.name.to_sym, serializer: element.descriptor.serializer_class
        when Associations::HasMany, Associations::HasManyThrough, Associations::HasAndBelongsToMany
          has_many element.name.to_sym, serializer: element.descriptor.serializer_class, if: :show?
        else
          attribute element.name.to_sym
        end
      end
    end

    class_methods do
      delegate :entity, to: :model_class

      def model_class = name
        .chomp('Serializer')
        .constantize
    end

    def _mention = Mention::Component
      .new(resource: object)
      .to_html

    def _metadata = {
      icon: self.class.entity.icon.to_s.dasherize,
      descriptor: object.to_s,
      url: Rails.application.routes.url_helpers.polymorphic_path(object)
    }

    def mention?
      instance_options[:mention]
    end

    def metadata?
      instance_options[:metadata]
    end

    def show?
      instance_options[:template] == 'show'
    end
  end
end
