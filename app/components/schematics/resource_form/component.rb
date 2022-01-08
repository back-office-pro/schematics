# frozen_string_literal: true

module Schematics
  module ResourceForm
    class Component < ApplicationComponent
      delegate :rich_text_area_tag, to: :helpers
      delegate :new_record?, to: :@resource
      delegate :entity, :human_attribute_name, to: :model_class

      def initialize(resource:, url: nil, attributes: nil, cancel_path: nil)
        super
        @resource = resource
        @url = url
        @attributes = attributes || entity.fillable_elements
        @cancel_path = cancel_path || resource
      end

      private

      def model_class
        @resource.class
      end
    end
  end
end
