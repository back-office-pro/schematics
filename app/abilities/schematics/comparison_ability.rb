# frozen_string_literal: true

module Schematics
  class ComparisonAbility < ApplicationAbility
    def initialize
      super
      can %i[create show], ::Comparison
    end
  end
end
