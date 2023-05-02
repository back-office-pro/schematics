# frozen_string_literal: true

module Schematics
  class SearchAbility < ApplicationAbility
    def initialize
      super
      can %i[create show], Core::Search
    end
  end
end
