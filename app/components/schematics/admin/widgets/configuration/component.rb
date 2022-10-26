# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module Configuration
        class Component < ApplicationComponent
          delegate :icon, to: '::Configuration.entity'

          def caption = t('.caption')

          def title = t('.title')
        end
      end
    end
  end
end
