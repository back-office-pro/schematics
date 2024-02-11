# frozen_string_literal: true

module Schematics
  module Button
    module Help
      class Component < ApplicationComponent
        ALLOWLIST = [
          ::Migration,
          ::Import,
          ::Stat,
          ::Chart,
          ::Configuration,
          ::Role,
          ::APIKey,
          ::UserGroup,
          ::WebhookEndpoint,
          ::Template
        ].freeze

        delegate :entity, :human_name_plural, to: :model_class, allow_nil: true, private: true
        delegate :core?, to: :entity, allow_nil: true, private: true
        delegate :locale, to: :current_user, private: true
        delegate :icon, to: '::Documentation.entity'

        option :wrapper_css_classes, default: -> { 'btn btn-sm btn-icon-split' }
        option :text_css_classes, default: -> { 'd-none d-lg-inline' }
        option :tooltip, default: -> { true }
        option :icon_css_classes, optional: true
        option :model_class, optional: true

        class << self
          def dropdown_item = new(
            wrapper_css_classes: 'dropdown-item',
            icon_css_classes: 'fa-fw me-3',
            text_css_classes: '',
            tooltip: false
          )
        end

        def data = {
          'bs-toggle': ('offcanvas' if model_class && !core?),
          'bs-target': ('#documentation' if model_class && !core?),
          controller: ('tooltip' if tooltip),
          'bs-custom-class': ('responsive-button-tooltip' if tooltip)
        }.compact

        def title = t('.text')

        def target
          '_blank' if external_doc?
        end

        def rel
          'noreferrer' if external_doc?
        end

        def url
          return '#' unless external_doc?

          ::Tenant.url(path:)
        end

        def render?
          external_doc? || !core?
        end

        private

        def external_doc?
          !model_class || ALLOWLIST.include?(model_class)
        end

        def path = File.join(['/docs', locale, slug].compact)

        def slug = human_name_plural
          .to_s
          .gsub(/\b\w{1,2}\b/, '')
          .parameterize(separator: '-')
      end
    end
  end
end
