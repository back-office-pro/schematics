# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Viewer
    module RichText
      class Component < ApplicationComponent
        delegate :icon, :entity, :name, to: :@attribute
        delegate :model_class, to: :entity
        with_collection_parameter :attribute

        def initialize(attribute:, resource:)
          super
          @attribute = attribute
          @resource = resource
        end

        def id = dom_id(@attribute)

        def render?
          value.present?
        end

        def title
          model_class.human_attribute_name(name)
        end

        def value
          @resource.public_send(name)
        end
      end
    end
  end
end
