# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module QuotaEntities
        class Component < ApplicationComponent
          delegate :entities_size,
                   :quota_entities,
                   :quota_entities_percentage,
                   to: '::Subscription.instance'

          def icon = :bezier_curve

          def title = t('.title')

          def render?
            can?(:cancel, ::Subscription)
          end
        end
      end
    end
  end
end
