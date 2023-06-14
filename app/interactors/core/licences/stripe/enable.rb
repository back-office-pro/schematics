# frozen_string_literal: true

module Core
  module Licences
    module Stripe
      class Enable
        include Interactor::Organizer

        before { context.params = { cancel_at_period_end: false } }

        organize Load, Update
      end
    end
  end
end
