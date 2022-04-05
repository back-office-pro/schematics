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

      def data
        return unless editable?

        {
          'content-editable-target': 'resource',
          action: 'click->content-editable#toggle'
        }
      end
    end
  end
end
