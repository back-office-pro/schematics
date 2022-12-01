# frozen_string_literal: true

module Schematics
  module ResourceDetails
    class Component < ApplicationComponent
      delegate :entity, to: :model_class
      option :resource
      option :model_class, default: proc { resource.class }
      option :editable, default: proc { false }

      def component_for(field)
        return EditInPlace::Component.new(resource:, field:) if editable?(field)

        Resource::Component.new(resource:, field:, enable_buttons: enable_buttons?(field))
      end

      def elements = entity
        .renderable_elements
        .excluding(entity.has_many_and_through_and_belongs_to_many_associations)
        .reject_is_a?(Attributes::RichText, Attributes::Attachments, Attributes::Uuid)

      private

      def editable?(element)
        enable_buttons?(element) && !element.is_a?(Behaviours::Preloadable)
      end

      def enable_buttons?(element)
        editable &&
          can?(:update, resource) &&
          element.is_a?(Behaviours::Fillable) &&
          !element.readonly?
      end
    end
  end
end
