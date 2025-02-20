# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Viewer
    module Settings
      class Component < ApplicationComponent
        delegate :listable_elements, :table_name, :model_class, to: :entity
        use_helpers :viewers, :viewer
        option :entity

        def title = t('.title')

        def other_viewers = viewers.excluding(viewer)
      end
    end
  end
end
