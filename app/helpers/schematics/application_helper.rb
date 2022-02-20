# frozen_string_literal: true

module Schematics
  module ApplicationHelper
    include Pagy::Frontend
    include FontAwesome5::Rails::IconHelper
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
  end
end
