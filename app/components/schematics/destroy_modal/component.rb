module Schematics
  module DestroyModal
    class Component < ::ViewComponent::Base
      delegate :fa_icon, to: :helpers
      delegate :class, to: :resource, prefix: true
      delegate :entity, :model_name, to: :resource_class
      attr_reader :resource

      def initialize(resource:, resources:, attachments:)
        @resource = resource
        @resources = resources
        @attachments = attachments
      end
    end
  end
end
