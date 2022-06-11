# frozen_string_literal: true

module Schematics
  module Viewer
    module SwitchButtonGroup
      class Component < ApplicationComponent
        delegate :id, to: :@resource

        def initialize(resource:, resources:)
          super
          @resource = resource
          @resources = resources
        end

        def data = {
          action: 'click->comparison#toggleButton',
          'comparison-target': 'switch'
        }

        def render?
          @resources.reject(&:deleted?).size > 1 && !@resource.deleted? # rubocop:disable Performance/Count
        end
      end
    end
  end
end
