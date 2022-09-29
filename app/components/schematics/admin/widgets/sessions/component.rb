# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module Sessions
        class Component < ApplicationComponent
          delegate :icon, to: '::Session.entity'

          def caption = t('.caption')

          def title = t('.title')
        end
      end
    end
  end
end
