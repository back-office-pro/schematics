# frozen_string_literal: true

module Schematics
  module Button
    module Edit
      class Component < ApplicationComponent
        delegate :can?, to: :helpers
        delegate :entity, to: :model_class

        def initialize(resource:, compact: true)
          super
          @resource = resource
          @compact = compact
        end

        def render?
          can?(:update, @resource)
        end

        def url
          case entity
          when Schematics::Entities::Singleton
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
            ('ml-2' unless compact?)
          ].compact
        end

        def data
          return {} unless compact?

          {
            toggle: 'tooltip',
            placement: 'top',
            title: t('schematics.application.button.tooltip.edit')
          }
        end

        def compact?
          @compact
        end

        private

        def model_class
          @resource.class
        end
      end
    end
  end
end
