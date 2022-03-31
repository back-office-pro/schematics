# frozen_string_literal: true

module Schematics
  module ApplicationHelper
    include Pagy::Frontend
    delegate :licence, to: :current_ability

    def settings(key)
      Rails.cache.fetch("settings/#{key}") do
        ::Setting
          .with_attached_company_logo
          .instance
          .public_send(key)
      end
    end

    def preferences(key, default = nil)
      current_user
        &.preferences
        &.fetch(key.to_s, default)
    end

    def i18n_javascript
      t('javascript')
        .deep_transform_keys { _1.to_s.camelize(:lower) }
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety
    end

    def confirm_data
      {
        confirm: t('schematics.application.delete.title'),
        text: t('schematics.application.delete.subtitle'),
        'confirm-button-text': t('schematics.application.button.confirm'),
        'cancel-button-text': t('schematics.application.button.cancel'),
        'sweet-alert-type': 'error',
        'allow-outside-click': false,
        'custom-class': ('disable-animation' if Rails.env.test?)
      }
    end

    def fa_icon(icon, class: nil, size: nil, animation: nil, **kwargs)
      tag.i(
        class: ['solid', icon.to_s.dasherize, size, animation]
          .compact
          .map { "fa-#{_1}" }
          .push(binding.local_variable_get(:class)),
        **kwargs
      )
    end
  end
end
