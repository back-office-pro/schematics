# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class SessionAbility < ApplicationAbility
    def initialize(user, mod)
      super
      case user
      when Guest::User
        can :create, mod::Session
      when proc(&:admin?)
        can %i[create read destroy], mod::Session
        cannot :new, mod::Session
      end
      cannot %i[duplicate import], mod::Session
    end
  end
end
