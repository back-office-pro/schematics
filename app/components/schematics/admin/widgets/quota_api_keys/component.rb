# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module QuotaApiKeys
        class Component < ApplicationComponent
          delegate :icon, to: '::ApiKey.entity'
          delegate :api_keys_size,
                   :quota_api_keys,
                   :quota_api_keys_percentage,
                   to: '::Subscription.instance'

          def title = t('.title')

          def render?
            can?(:cancel, ::Subscription)
          end
        end
      end
    end
  end
end
