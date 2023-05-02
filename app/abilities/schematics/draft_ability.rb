# frozen_string_literal: true

module Schematics
  class DraftAbility < ApplicationAbility
    def initialize(user)
      super
      can :create, Core::Draft
      can %i[show update destroy], Core::Draft, user:
    end
  end
end
