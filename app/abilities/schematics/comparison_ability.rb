# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class ComparisonAbility < ApplicationAbility
    def initialize(mod)
      super
      can %i[create show], mod::Comparison
    end
  end
end
