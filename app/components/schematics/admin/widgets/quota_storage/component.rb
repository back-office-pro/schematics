# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module QuotaStorage
        class Component < ApplicationComponent
          delegate :storage_size,
                   :quota,
                   :quota_storage_percentage,
                   to: 'Schematics::Licence.instance'

          def icon = :hdd

          def title = t('.title')
        end
      end
    end
  end
end
