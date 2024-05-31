# frozen_string_literal: true

module Schematics
  module Button
    module Support
      module Email
        class Component < Support::Component
          delegate :domain, to: '::Tenant', private: true
          delegate :email_support?, to: '::Subscription.instance', private: true
          delegate :icon, to: '::Message.entity'

          def support_email = "support@#{domain}"

          alias render? email_support?
        end
      end
    end
  end
end
