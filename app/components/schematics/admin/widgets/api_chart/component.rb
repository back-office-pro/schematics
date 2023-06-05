# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module ApiChart
        class Component < ApplicationComponent
          def icon = :signal

          def caption = t('.caption')

          def title = t('.title')

          def render?
            can?(:show, ::Chart.api)
          end
        end
      end
    end
  end
end
