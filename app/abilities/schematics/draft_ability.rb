# frozen_string_literal: true

module Schematics
  class DraftAbility < ApplicationAbility
    def initialize(user)
      super
      can :update, ::Draft, user:
    end
  end
end
