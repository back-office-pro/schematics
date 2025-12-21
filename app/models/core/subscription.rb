# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
class ::Subscription < Schematics::ApplicationRecord
  GATEWAY = ::Core::Subscriptions::Stripe

  attribute :default_locale, default: -> { Rails.configuration.i18n.default_locale }

  def load! = update!(GATEWAY::Fetch.call.data)
end
