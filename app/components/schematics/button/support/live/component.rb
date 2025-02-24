# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module Support
      module Live
        class Component < Support::Component
          delegate :live_support?, to: 'current_module::Subscription', private: true
          delegate :icon, to: 'current_module::Meeting.entity'

          def data = { controller: 'support', action: 'click->support#open' }

          alias render? live_support?
        end
      end
    end
  end
end
