# frozen_string_literal: true

module Core
  module Licences
    module Stripe
      class Cancel
        include Interactor::Organizer

        before { context.params = { cancel_at_period_end: true } }

        organize Load, Update
      end
    end
  end
end
