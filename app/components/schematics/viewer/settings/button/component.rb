# frozen_string_literal: true

module Schematics
  module Viewer
    module Settings
      module Button
        class Component < ApplicationComponent
          with_collection_parameter :viewer

          def initialize(viewer:, entity:)
            super
            @viewer = viewer
            @entity = entity
          end

          def icon = {
            table: :table,
            grid: :grip_vertical,
            calendar: :calendar_days
          }[@viewer]

          def data = {
            action: 'click->viewer-settings#switchLayout:prevent',
            'viewer-settings-viewer-param': @viewer,
            'viewer-settings-preference-param': "viewer_#{@entity.id}"
          }
        end
      end
    end
  end
end
