# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module QuotaStorage
        class Component < ApplicationComponent
          delegate :storage_size,
                   :quota,
                   :quota_storage_percentage,
                   to: 'Core::Licence.instance'

          def icon = :hdd

          def title = t('.title')

          def render?
            can?(:cancel, Core::Licence)
          end
        end
      end
    end
  end
end
