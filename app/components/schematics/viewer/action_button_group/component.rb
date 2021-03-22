module Schematics
  module Viewer
    module ActionButtonGroup
      class Component < ::ViewComponent::Base
        delegate :fa_icon, :current_ability, to: :helpers
        delegate :can?, to: :current_ability

        def initialize(resource:)
          super
          @resource = resource
        end
      end
    end
  end
end
