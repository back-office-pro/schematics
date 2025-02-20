# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Subscriptions
    module Stripe
      class Enable
        include Interactor::Organizer

        before { context.params = { cancel_at_period_end: false } }

        organize Fetch, Update
      end
    end
  end
end
