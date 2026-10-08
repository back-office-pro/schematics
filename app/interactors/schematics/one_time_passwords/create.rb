# frozen_string_literal: true

module Schematics
  module OneTimePasswords
    class Create
      include Interactor::Organizer

      organize Authenticate, Core::Sessions::SignIn
    end
  end
end
