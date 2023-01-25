# frozen_string_literal: true

module Schematics
  module Viewer
    module Grid
      class Component < Viewer::Component
        def carousel(resource)
          entity
            .attachment_attributes
            .map(&:name)
            .flat_map(&resource.method(:public_send))
        end

        def carousel_css_classes = %w[
          carousel-item
          active
          text-center
        ]

        def tbody_css_classes
          params[:page].presence && super
        end
      end
    end
  end
end
