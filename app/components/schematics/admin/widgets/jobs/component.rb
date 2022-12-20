# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module Jobs
        class Component < ApplicationComponent
          def caption = t('.caption')

          def icon = :tasks

          def title = t('.title')
        end
      end
    end
  end
end
