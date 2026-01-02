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
      module Toggle
        class Component < ApplicationComponent
          delegate :entity, to: :@field, private: true
          delegate :model_class, to: :entity, private: true
          delegate :preferences, to: :current_user, private: true

          with_collection_parameter :field

          def initialize(field:)
            super
            @field = field
          end

          def preference = "col_#{entity.id}_#{@field.id}"

          def label = model_class.human_attribute_name(@field.name)

          def checked?
            preferences.fetch(preference, true)
          end
        end
      end
    end
  end
end
