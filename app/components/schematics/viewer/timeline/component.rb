# frozen_string_literal: true

module Schematics
  module Viewer
    module Timeline
      class Component < ApplicationComponent
        delegate :versions, to: :@resource, private: true
        delegate :class, to: :@resource, prefix: :model, private: true
        delegate :entity, to: :model_class, private: true

        def initialize(resource:)
          super
          @resource = resource
        end

        def before_render
          @pagy, @versions = pagy(
            Version.timeline(current_ability, versions.includes(item: entity.includes))
          )
        end

        def render?
          @versions.any?
        end
      end
    end
  end
end
