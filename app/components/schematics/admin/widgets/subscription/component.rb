# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module Subscription
        class Component < ApplicationComponent
          delegate :icon, to: 'current_module::Subscription.entity'
          delegate :state_inactive?, to: :resource

          memoize def resource = current_module::Subscription.instance

          def render?
            can?(:cancel, current_module::Subscription)
          end
        end
      end
    end
  end
end
