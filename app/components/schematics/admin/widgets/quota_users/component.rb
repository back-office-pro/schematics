# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module QuotaUsers
        class Component < ApplicationComponent
          delegate :icon, to: '::User.entity'
          delegate :users_size,
                   :quota,
                   :quota_users_percentage,
                   to: '::Licence.instance'

          def title = t('.title')
        end
      end
    end
  end
end
