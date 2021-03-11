module Schematics
  module Resource
    class Component < ::ViewComponent::Base
      delegate :fa_icon, :confirm_data, to: :helpers

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
        @editable
      end
    end
  end
end
