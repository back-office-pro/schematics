# frozen_string_literal: true

module Schematics
  module Resource
    class Component < ApplicationComponent
      def initialize(resource:, field:, editable: false, highlight: nil)
        super
        @resource = resource
        @field = field
        @editable = editable
        @highlight = highlight
      end

      def value
        @resource.public_send(@field.name)
      end

      def editable?
        @editable &&
          can?(:update, @resource) &&
          !@field.try(:readonly?) &&
          @field.is_a?(Behaviours::Fillable)
      end

      def div_data
        return unless editable?

        { controller: 'edit-in-place' }
      end

      def span_data
        return unless editable?

        {
          'edit-in-place-target': 'resource',
          action: 'click->edit-in-place#toggle'
        }
      end
    end
  end
end
