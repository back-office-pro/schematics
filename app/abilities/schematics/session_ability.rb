# frozen_string_literal: true

module Schematics
  class SessionAbility < ApplicationAbility
    def initialize(user)
      super
      case user
      when Guest::User
        can :create, Core::Session
      when proc(&:admin?)
        can %i[create read destroy], Core::Session
        cannot :new, Core::Session
      end
      cannot %i[duplicate import], Core::Session
    end
  end
end
