# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class ChartAbility < ApplicationAbility
    def initialize(user, mod)
      super
      cannot %i[duplicate update destroy archive], mod::Chart.api
      cannot :show, mod::Chart.api unless user.admin?
    end
  end
end
