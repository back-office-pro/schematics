# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module QuotaEntities
        class Component < ApplicationComponent
          delegate :entities_size, :quota_entities, to: '::Subscription.instance'

          def icon = :bezier_curve

          def title = t('.title')

          def percentage
            entities_size * 100 / quota_entities
          end

          def render?
            can?(:create, ::Migration)
          end
        end
      end
    end
  end
end
