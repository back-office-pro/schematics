module Schematics
  module ApplicationHelper
    include Pagy::Frontend
    include FontAwesome5::Rails::IconHelper

    def setting(key)
      Rails.cache.fetch("settings:#{key}") do
        Setting.with_attached_company_logo.instance.send(key)
      end
    end

    def user_setting(key)
      Rails.cache.fetch("user_settings:#{current_user.id}:#{key}") do
        current_user.preferences[key.to_s]
      end
    end

    def confirm_data
      {
        confirm: t('schematics.application.delete.title'),
        text: t('schematics.application.delete.subtitle'),
        'confirm-button-text': t('schematics.application.button.confirm'),
        'cancel-button-text': t('schematics.application.button.cancel'),
        'sweet-alert-type': 'error',
        'allow-outside-click': false,
        'custom-class': ('disable-animation' if Rails.env.test?),
      }
    end
  end
end
