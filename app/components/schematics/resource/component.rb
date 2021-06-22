# frozen_string_literal: true

module Schematics
  module Resource
    class Component < ApplicationComponent
      delegate :confirm_data, to: :helpers

      def initialize(resource:, field:, editable: false)
        super
        @resource = resource
        @field = field
        @editable = editable
      end

      def value
        @resource.instance_eval(@field.name)
      end

      def editable?
        @editable && !@field.try(:readonly?)
      end
    end
  end
end
