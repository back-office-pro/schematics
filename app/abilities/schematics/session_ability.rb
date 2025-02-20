# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class SessionAbility < ApplicationAbility
    def initialize(user)
      super
      case user
      when Guest::User
        can :create, ::Session
      when proc(&:admin?)
        can %i[create read destroy], ::Session
        cannot :new, ::Session
      end
      cannot %i[duplicate import], ::Session
    end
  end
end
