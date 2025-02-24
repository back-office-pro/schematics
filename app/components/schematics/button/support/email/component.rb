# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module Support
      module Email
        class Component < Support::Component
          delegate :support_email, to: '::Server', private: true
          delegate :email_support?, to: 'current_module::Subscription', private: true
          delegate :icon, to: 'current_module::Message.entity'

          alias render? email_support?
        end
      end
    end
  end
end
