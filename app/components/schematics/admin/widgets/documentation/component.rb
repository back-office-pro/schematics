# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module Documentation
        class Component < ApplicationComponent
          delegate :documentation_path, to: 'Schematics::Engine.routes.url_helpers'

          def caption = t('.caption')

          def icon = :project_diagram

          def title = t('.title')
        end
      end
    end
  end
end
