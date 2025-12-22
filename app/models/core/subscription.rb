# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
class ::Subscription < Schematics::ApplicationRecord
  GATEWAY = ::Core::Subscriptions::Stripe

  def load! = update!(GATEWAY::Fetch.call.data)
end
