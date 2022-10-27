# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module QuotaEntities
        class Component < ApplicationComponent
          delegate :entities_size,
                   :quota,
                   :quota_entities_percentage,
                   to: '::Licence.instance'

          def icon = :bezier_curve

          def title = t('.title')
        end
      end
    end
  end
end
