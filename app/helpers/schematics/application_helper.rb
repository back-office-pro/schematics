module Schematics
  module ApplicationHelper
    include FontAwesome5::Rails::IconHelper

    def app_name
      Rails.application.class.module_parent_name
    end

    def title
      "Home"
    end
  end
end
