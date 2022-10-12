# frozen_string_literal: true

require 'stripe'

::Stripe.api_key = Schematics::Engine
                   .credentials
                   .dig(:stripe, Schematics::Engine.app_env, :secret_key)
