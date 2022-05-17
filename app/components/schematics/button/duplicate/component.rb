# frozen_string_literal: true

module Schematics
  module Button
    module Duplicate
      class Component < ApplicationComponent
        def initialize(resource:)
          super
          @resource = resource
        end

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split ms-2]

        def render?
          can?(:duplicate, @resource)
        end
      end
    end
  end
end
