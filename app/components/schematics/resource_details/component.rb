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

      def elements
        entity
          .renderable_elements
          .excluding(entity.has_many_and_through_and_belongs_to_many_associations)
          .reject_is_a?(Attributes::RichText, Attributes::Attachments)
      end

      def constant(element)
        return :EditInPlace if editable?(element)

        :Resource
      end

      private

      def editable?(element)
        @editable &&
          can?(:update, @resource) &&
          element.is_a?(Behaviours::Fillable) &&
          !element.readonly? &&
          !element.is_a?(Behaviours::Preloadable)
      end
    end
  end
end
