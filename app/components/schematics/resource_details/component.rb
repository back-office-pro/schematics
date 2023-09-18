# frozen_string_literal: true

module Schematics
  module ResourceDetails
    class Component < ApplicationComponent
      delegate :entity, to: :model_class
      option :resource
      option :model_class, default: -> { resource.class }
      option :editable, default: -> { false }

      def component_for(field)
        return EditInPlace::Component.new(resource:, field:) if editable?(field)

        Resource::Component.new(resource:, field:, enable_buttons: enable_buttons?(field))
      end

      def elements = entity
        .renderable_elements
        .excluding(entity.has_many_and_through_and_belongs_to_many_associations)
        .grep_v(Attributes::RichText)
        .grep_v(Attributes::Attachments)
        .grep_v(Attributes::Uuid)

      private

      def editable?(element)
        enable_buttons?(element) && !element.is_a?(Attributes::Attachment)
      end

      def enable_buttons?(element)
        editable &&
          can?(:update, resource, element.name.to_sym) &&
          element.is_a?(Behaviours::Fillable) &&
          !element.readonly?
      end
    end
  end
end
