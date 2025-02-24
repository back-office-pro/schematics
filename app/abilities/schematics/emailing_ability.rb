# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class EmailingAbility < ApplicationAbility
    def initialize(mod)
      super
      can :email, :all
      cannot :email, mod::Emailing
    end
  end
end
