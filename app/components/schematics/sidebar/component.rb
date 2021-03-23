module Schematics
  module Sidebar
    class Component < ::ViewComponent::Base
      delegate :fa_icon, :setting, :user_setting, :current_ability, to: :helpers
      delegate :entities, to: 'Schematics::Schema.instance'
      delegate :cannot?, to: :current_ability

      def toggled?
        user_setting(:sidebar_toggled)
      end
    end
  end
end
