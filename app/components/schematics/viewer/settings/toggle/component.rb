# Copyright © 2025 Dev & Software. All rights reserved.
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
