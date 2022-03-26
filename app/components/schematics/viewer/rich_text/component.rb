# frozen_string_literal: true

module Schematics
  module Viewer
    module RichText
      class Component < ApplicationComponent
        delegate :icon, :entity, to: :@attribute
        delegate :model_class, to: :entity
        with_collection_parameter :attribute

        def initialize(attribute:, resource:)
          super
          @attribute = attribute
          @resource = resource
        end

        def render?
          value.present?
        end

        def id
          @id ||= "collapse-#{SecureRandom.base58}"
        end

        def title
          model_class.human_attribute_name(@attribute.name)
        end

        def value
          @resource.public_send(@attribute.name)
        end
      end
    end
  end
end
