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

          def id = "carousel-#{resource.id}"

          def css_classes(index)
            return %w[carousel-item text-center] unless index.zero?

            %w[carousel-item text-center active]
          end
        end
      end
    end
  end
end
