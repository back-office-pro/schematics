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
          ::ApiKey,
          ::UserGroup,
          ::WebhookEndpoint
        ].freeze

        delegate :url, to: ::Tenant, private: true
        delegate :human_name_plural, to: :model_class, allow_nil: true, private: true
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

        def data
          { controller: 'tooltip', 'bs-custom-class': 'responsive-button-tooltip' } if tooltip
        end

        def title = t('.text')

        def path = File.join(['/docs', locale, slug].compact)

        def render?
          !model_class || ALLOWLIST.include?(model_class)
        end

        private

        def slug = human_name_plural
          .to_s
          .gsub(/\b\w{1,2}\b/, '')
          .parameterize(separator: '-')
      end
    end
  end
end
