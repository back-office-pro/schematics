module Schematics
  module Sidebar
    class Component < ::ViewComponent::Base
      delegate :fa_icon, :setting, :current_ability, to: :helpers
      delegate :entities, to: 'Schematics::SCHEMA'
      delegate :cannot?, to: :current_ability
    end
  end
end
