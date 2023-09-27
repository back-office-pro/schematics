# frozen_string_literal: true

require 'stripe'

Stripe.open_timeout = 5
Stripe.read_timeout = 5
Stripe.api_key = Schematics::Engine
                 .credentials
                 .dig(:stripe, Rails.env.to_sym, :secret_key)
