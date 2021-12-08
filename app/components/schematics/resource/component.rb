# frozen_string_literal: true

module Schematics
  module Resource
    class Component < ApplicationComponent
      delegate :confirm_data, :can?, to: :helpers

      def initialize(resource:, field:, editable: false)
        super
        @resource = resource
        @field = field
        @editable = editable
      end

      def value
        @resource.public_send(@field.name)
      end

      def editable?
        @editable && can?(:update, @resource) && !@field.try(:readonly?)
      end

      def error?
        value.is_a?(StandardError)
      end
    end
  end
end
