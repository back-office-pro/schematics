# frozen_string_literal: true

module Schematics
  class DraftAbility < ApplicationAbility
    def initialize(user)
      super
      can :create, ::Draft
      can %i[show update destroy], ::Draft, user:
    end
  end
end
