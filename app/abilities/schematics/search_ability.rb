# frozen_string_literal: true

module Schematics
  class SearchAbility < ApplicationAbility
    def initialize
      super
      can :create, ::Search
      can :show, ::Search
    end
  end
end
