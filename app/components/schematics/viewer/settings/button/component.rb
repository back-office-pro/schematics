# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
            calendar: :calendar_days,
            map: :map_location_dot,
            kanban: :table_columns
          }[@viewer]

          def data = {
            controller: 'tooltip',
            action: 'click->viewer-settings#switchLayout:prevent',
            'viewer-settings-viewer-param': @viewer,
            'viewer-settings-preference-param': "viewer_#{@entity.id}",
            'bs-title': t(".#{@viewer}")
          }
        end
      end
    end
  end
end
