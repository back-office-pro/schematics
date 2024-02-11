# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module APIChart
        class Component < ApplicationComponent
          def icon = :signal

          def caption = t('.caption')

          def title = t('.title')

          memoize def resource = ::Chart
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
