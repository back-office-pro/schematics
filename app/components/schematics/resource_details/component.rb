# frozen_string_literal: true

module Schematics
  module ResourceDetails
    class Component < ApplicationComponent
      delegate :entity, to: :@model_class

      def initialize(resource:, model_class: nil, editable: false)
        super
        @resource = resource
        @model_class = model_class || resource.class
        @editable = editable
      end

      def component_for(field)
        return EditInPlace::Component.new(resource: @resource, field:) if editable?(field)

        Resource::Component.new(resource: @resource, field:, enable_buttons: enable_buttons?(field))
      end

      def elements
        entity
          .renderable_elements
          .excluding(entity.has_many_and_through_and_belongs_to_many_associations)
          .reject_is_a?(Attributes::RichText, Attributes::Attachments)
      end

      private

      def editable?(element)
        enable_buttons?(element) && !element.is_a?(Behaviours::Preloadable)
      end

      def enable_buttons?(element)
        @editable &&
          can?(:update, @resource) &&
          element.is_a?(Behaviours::Fillable) &&
          !element.readonly?
      end
    end
  end
end
