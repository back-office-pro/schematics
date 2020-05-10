module Schematics
  module ApplicationHelper
    include Pagy::Frontend
    include FontAwesome5::Rails::IconHelper

    def setting(key)
      Rails.cache.fetch("settings_#{key}") do
        Setting.instance.send(key)
      end
    end
  end
end
