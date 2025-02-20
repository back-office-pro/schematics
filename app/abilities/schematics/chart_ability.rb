# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class ChartAbility < ApplicationAbility
    def initialize(user)
      super
      cannot %i[duplicate update destroy archive], ::Chart.api
      cannot :show, ::Chart.api unless user.admin?
    end
  end
end
