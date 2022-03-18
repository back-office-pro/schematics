# frozen_string_literal: true

module Schematics
  module Viewer
    module SwitchButtonGroup
      class Component < ApplicationComponent
        delegate :can?, to: :helpers
        delegate :id, to: :@resource

        def initialize(resource:)
          super
          @resource = resource
        end

        def render?
          can?(:create, ::Comparison)
        end

        def data
          { action: 'click->comparison#toggleButton', 'comparison-target': 'switch' }
        end
      end
    end
  end
end
