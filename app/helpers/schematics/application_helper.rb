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
  end
end
