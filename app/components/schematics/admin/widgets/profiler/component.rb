# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module Profiler
        class Component < ApplicationComponent
          def caption = t('.caption')

          def icon = :tachometer_alt

          def title = t('.title')
        end
      end
    end
  end
end
