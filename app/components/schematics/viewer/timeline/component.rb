# frozen_string_literal: true

module Schematics
  module Viewer
    module Timeline
      class Component < ApplicationComponent
        def initialize(versions:, pagy:)
          super
          @versions = versions
          @pagy = pagy
        end

        def render?
          @versions.any?
        end
      end
    end
  end
end
