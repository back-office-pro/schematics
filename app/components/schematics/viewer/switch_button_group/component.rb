# frozen_string_literal: true

module Schematics
  module Viewer
    module SwitchButtonGroup
      class Component < ApplicationComponent
        delegate :id, :deleted?, to: :resource
        option :resource
        option :resources

        def data = {
          action: 'click->comparison#toggleButton click->bulk-action#toggleButton',
          'comparison-target': 'switch',
          'bulk-action-target': 'switch'
        }

        def render?
          resources.reject(&:deleted?).size > 1 && # rubocop:disable Performance/Count
            can?(:create, ::Comparison) &&
            can?(:show, resource) &&
            !deleted?
        end
      end
    end
  end
end
