# frozen_string_literal: true

module Application
  module Licence
    module Stripe
      class Update
        include Interactor::Organizer

        organize Load, Cancel
      end
    end
  end
end
