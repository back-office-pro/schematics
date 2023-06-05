# frozen_string_literal: true

module Schematics
  class ChartAbility < ApplicationAbility
    def initialize
      super
      cannot %i[duplicate update destroy archive], ::Chart.api
    end
  end
end
