# frozen_string_literal: true

module Schematics
  module Button
    module Edit
      class Component < ApplicationComponent
        delegate :can?, to: :helpers
        delegate :class, to: :@resource, prefix: :model, private: true
        delegate :entity, to: :model_class, private: true

        def initialize(resource:, compact: true)
          super
          @resource = resource
          @compact = compact
        end

        def render?
          can?(:edit, @resource)
        end

        def url
          case entity
          when Entities::Singleton
            edit_polymorphic_path(model_class)
          else
            edit_polymorphic_path(@resource)
          end
        end

        def css_classes
          [
            'btn',
            'btn-primary',
            'btn-sm',
            ('btn-icon-split' unless compact?),
            ('ms-2' unless compact?)
          ].compact
        end

        def data
          return {} unless compact?

          { 'bs-toggle': 'tooltip', 'bs-placement': 'top' }
        end

        def title
          return unless compact?

          t('.text')
        end

        def compact?
          @compact
        end
      end
    end
  end
end
