# frozen_string_literal: true

module Schematics
  class DraftAbility < ApplicationAbility
    def initialize(user, mod)
      super
      can :create, mod::Draft
      can %i[show update destroy], mod::Draft, user:
    end
  end
end
