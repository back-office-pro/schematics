# frozen_string_literal: true

module Schematics
  class ComparisonAbility < ApplicationAbility
    def initialize(mod)
      super
      can :create, mod::Comparison
      can :show, mod::Comparison
    end
  end
end
