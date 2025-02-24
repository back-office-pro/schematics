# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class DraftAbility < ApplicationAbility
    def initialize(user, mod)
      super
      can :update, mod::Draft, user:
    end
  end
end
