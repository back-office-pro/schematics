# frozen_string_literal: true

module Schematics
  module Viewer
    module SwitchButtonGroup
      class Component < ApplicationComponent
        delegate :id, :deleted?, to: :resource
        option :resource
        option :resources

        def data = {
          action: 'click->comparison#toggleButton',
          'comparison-target': 'switch'
        }

        def render?
          resources.reject(&:deleted?).size > 1 && !deleted? # rubocop:disable Performance/Count
        end
      end
    end
  end
end
