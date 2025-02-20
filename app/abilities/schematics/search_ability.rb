# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class SearchAbility < ApplicationAbility
    def initialize
      super
      can %i[autocomplete create show], ::Search
    end
  end
end
