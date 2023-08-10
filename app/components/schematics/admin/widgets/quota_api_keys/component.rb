# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module QuotaApiKeys
        class Component < ApplicationComponent
          delegate :icon, to: '::ApiKey.entity'
          delegate :api_keys_size,
                   :quota,
                   :quota_api_keys_percentage,
                   to: '::Licence.instance'

          def title = t('.title')

          def render?
            can?(:cancel, ::Licence)
          end
        end
      end
    end
  end
end
