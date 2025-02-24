# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class SearchAbility < ApplicationAbility
    def initialize(mod)
      super
      can %i[autocomplete create show], mod::Search
    end
  end
end
