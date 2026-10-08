# frozen_string_literal: true

module Schematics
  class RecordAbility < ApplicationAbility
    def initialize
      super
      can %i[create restore], :all
    end
  end
end
