# frozen_string_literal: true

module Schematics
  class SearchAbility < ApplicationAbility
    def initialize(mod)
      super
      can :create, mod::Search
      can :show, mod::Search
    end
  end
end
