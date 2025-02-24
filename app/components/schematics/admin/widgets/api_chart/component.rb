# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module APIChart
        class Component < ApplicationComponent
          def icon = :signal

          def caption = t('.caption')

          def title = t('.title')

          def path = resource_path(resource)

          memoize def resource = current_module::Chart
            .with_string_translations
            .api

          def render?
            can?(:show, resource)
          end
        end
      end
    end
  end
end
