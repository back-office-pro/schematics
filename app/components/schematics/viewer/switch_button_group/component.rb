# frozen_string_literal: true

module Schematics
  module Viewer
    module SwitchButtonGroup
      class Component < ApplicationComponent
        delegate :id, to: :@resource

        def initialize(resource:)
          super
          @resource = resource
        end

        def render?
          !@resource.deleted?
        end

        def data
          { action: 'click->comparison#toggleButton', 'comparison-target': 'switch' }
        end
      end
    end
  end
end
