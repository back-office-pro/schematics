# frozen_string_literal: true

module Schematics
  class ComparisonAbility < ApplicationAbility
    def initialize
      super
      can :create, ::Comparison
      can :show, ::Comparison
    end
  end
end
