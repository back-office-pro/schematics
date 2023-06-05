# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module ApiChart
        class Component < ApplicationComponent
          delegate :api_chart_path, to: 'Schematics::Engine.routes.url_helpers'

          def icon = :signal

          def caption = t('.caption')

          def title = t('.title')

          def render?
            can?(:index, ::Chart)
          end
        end
      end
    end
  end
end
