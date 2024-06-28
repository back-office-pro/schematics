# frozen_string_literal: true

module Schematics
  class AlertAbility < ApplicationAbility
    def initialize
      super
      can :alert, :all
      cannot :alert, ::Alert
    end
  end
end
