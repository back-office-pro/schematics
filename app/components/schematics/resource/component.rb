module Schematics
  module Resource
    class Component < ::ViewComponent::Base
      delegate :fa_icon, to: :helpers

      def initialize(resource:, field:, editable: false)
        @resource = resource
        @field = field
        @editable = false
      end

      def value
        @resource.instance_eval(@field.name)
      end

      def editable?
        @editable
      end
    end
  end
end
