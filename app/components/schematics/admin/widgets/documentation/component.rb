# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module Documentation
        class Component < ApplicationComponent
          delegate :icon, to: 'mod::Documentation.entity'

          def caption = t('.caption')

          def title = t('.title')
        end
      end
    end
  end
end
