# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class DraftAbility < ApplicationAbility
    def initialize(user)
      super
      can :update, ::Draft, user:
    end
  end
end
