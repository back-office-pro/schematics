# frozen_string_literal: true

module Schematics
  module Viewer
    module EventButtonGroup
      class Component < ApplicationComponent
        delegate :can?, to: :current_ability
        delegate :entity, to: '@resource.class', private: true

        def initialize(resource:, compact: true)
          super
          @resource = resource
          @compact = compact
        end

        def events
          entity
            .events
            .select { |event| @resource.public_send(:"may_#{event.name}?") }
        end

        def render?
          can?(:trigger, @resource)
        end

        def css_class
          return 'btn-group' if compact?

          'd-inline ml-2'
        end

        def compact?
          @compact
        end
      end
    end
  end
end
