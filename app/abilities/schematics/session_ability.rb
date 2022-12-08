# frozen_string_literal: true

module Schematics
  class SessionAbility < ApplicationAbility
    def initialize(user, mod)
      super
      case user
      when Guest::User
        can %i[create], mod::Session
      when proc(&:admin?)
        can %i[create read destroy], mod::Session
      end
    end
  end
end
