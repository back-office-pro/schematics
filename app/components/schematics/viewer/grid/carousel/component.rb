# frozen_string_literal: true

module Schematics
  module Viewer
    module Grid
      module Carousel
        class Component < ApplicationComponent
          delegate :entity, to: 'resource.class', private: true
          option :resource

          def attachments = entity
            .attachment_attributes
            .map(&:name)
            .flat_map(&resource.method(:public_send))

          def id = dom_id(resource, 'carousel')

          def css_classes(index)
            class_names('carousel-item', 'text-center', active: index.zero?)
          end
        end
      end
    end
  end
end
