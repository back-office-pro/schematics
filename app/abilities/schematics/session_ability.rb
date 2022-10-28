# frozen_string_literal: true

module Schematics
  class SessionAbility < ApplicationAbility
    def initialize(user)
      super
      case user
      when Guest::User
        can %i[create], ::Session
      when proc(&:admin?)
        can %i[create read destroy], ::Session
      end
    end
  end
end
