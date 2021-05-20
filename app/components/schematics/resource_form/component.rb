module Schematics
  module ResourceForm
    class Component < ApplicationComponent
      delegate :rich_text_area_tag, to: :helpers
      delegate :new_record?, to: :resource
      delegate :class, to: :resource, prefix: true
      delegate :entity, to: :resource_class
      attr_reader :resource

      def initialize(resource:, url: nil, attributes: nil, cancel_path: nil)
        super
        @resource = resource
        @url = url
        @attributes = attributes || entity.fillable_elements
        @cancel_path = cancel_path || resource
      end
    end
  end
end
