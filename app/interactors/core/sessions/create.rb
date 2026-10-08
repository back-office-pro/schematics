# frozen_string_literal: true

module Core
  module Sessions
    class Create
      include Interactor::Organizer

      organize Authenticate, Omniauthenticate, Impersonate, SignIn
    end
  end
end
