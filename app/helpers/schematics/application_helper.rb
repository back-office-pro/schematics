module Schematics
  module ApplicationHelper
    include FontAwesome5::Rails::IconHelper

    def app_name
      Rails.application.class.module_parent_name
    end

    def title
      I18n.t(:title, scope: [:schematics, controller_name.to_sym, action_name.to_sym])
    end
  end
end
