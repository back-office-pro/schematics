# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Viewer
    module Timeline
      class Component < ApplicationComponent
        LIMIT = 10

        delegate :paper_trail_versions, to: :resource, private: true
        delegate :class, to: :resource, prefix: :model, private: true
        delegate :entity, to: :model_class, private: true
        option :resource

        def before_render
          @pagy, @versions = pagy(
            Version.timeline(
              current_ability,
              paper_trail_versions.includes(item: entity.includes)
            ),
            limit: LIMIT
          )
        end

        def render?
          @versions.any?
        end
      end
    end
  end
end
