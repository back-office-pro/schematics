# frozen_string_literal: true

module Schematics
  module Viewer
    module ActionButtonGroup
      class Component < ApplicationComponent
        def initialize(resource:)
          super
          @resource = resource
        end

        def constant
          return :Delete if resource_associations(resource: @resource).any?

          :Destroy
        end
      end
    end
  end
end
