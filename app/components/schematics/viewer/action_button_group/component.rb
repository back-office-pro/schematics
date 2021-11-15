# frozen_string_literal: true

module Schematics
  module Viewer
    module ActionButtonGroup
      class Component < ApplicationComponent
        delegate :can?, to: :current_ability
        delegate :resource_associations, :confirm_data, to: :helpers

        def initialize(resource:)
          super
          @resource = resource
        end
      end
    end
  end
end
