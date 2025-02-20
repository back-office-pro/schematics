# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class ComparisonAbility < ApplicationAbility
    def initialize
      super
      can %i[create show], ::Comparison
    end
  end
end
