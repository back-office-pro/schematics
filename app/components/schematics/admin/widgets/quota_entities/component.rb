# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module QuotaEntities
        class Component < ApplicationComponent
          delegate :quota_entities, to: '::Subscription'

          def icon = :bezier_curve

          def title = t('.title')

          def entities_size = ::SchemaCache
            .model_classes
            .size

          def percentage
            entities_size * 100 / quota_entities
          end

          def background_css_class
            return 'bg-danger' if entities_size >= quota_entities

            'bg-success'
          end

          def render?
            can?(:cancel, ::Subscription)
          end
        end
      end
    end
  end
end
