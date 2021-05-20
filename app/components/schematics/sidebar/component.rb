module Schematics
  module Sidebar
    class Component < ApplicationComponent
      delegate :setting, :user_setting, to: :helpers
      delegate :entities, to: 'Schematics::Schema.instance'
      delegate :cannot?, to: :current_ability

      def toggled?
        user_setting(:sidebar_toggled)
      end
    end
  end
end
