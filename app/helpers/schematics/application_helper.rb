module Schematics
  module ApplicationHelper
    include Pagy::Frontend
    include FontAwesome5::Rails::IconHelper

    def setting(key)
      Rails.cache.fetch("settings_#{key}") do
        Setting.with_attached_company_logo.instance.send(key)
      end
    end
  end
end
