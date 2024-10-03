# frozen_string_literal: true

require 'stripe'

Stripe.open_timeout = 5
Stripe.read_timeout = 5
