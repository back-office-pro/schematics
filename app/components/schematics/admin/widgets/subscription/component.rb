# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module Subscription
        class Component < ApplicationComponent
          delegate :icon, to: '::Subscription.entity'
          delegate :state_inactive?, to: :resource

          memoize def resource = ::Subscription.instance
        end
      end
    end
  end
end
