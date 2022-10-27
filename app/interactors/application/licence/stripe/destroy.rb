# frozen_string_literal: true

module Application
  module Licence
    module Stripe
      class Destroy
        include Interactor::Organizer

        organize Load, Cancel
      end
    end
  end
end
