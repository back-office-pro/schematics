module Schematics
  module Viewer
    module ActionButtonGroup
      class Component < ApplicationComponent
        delegate :can?, to: :current_ability

        def initialize(resource:)
          super
          @resource = resource
        end
      end
    end
  end
end
