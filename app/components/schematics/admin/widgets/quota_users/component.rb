# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module QuotaUsers
        class Component < ApplicationComponent
          delegate :icon, to: 'Core::User.entity'
          delegate :users_size,
                   :quota,
                   :quota_users_percentage,
                   to: 'Core::Licence.instance'

          def title = t('.title')

          def render?
            can?(:cancel, Core::Licence)
          end
        end
      end
    end
  end
end
