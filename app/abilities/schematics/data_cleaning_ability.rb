# frozen_string_literal: true

module Schematics
  class DataCleaningAbility < ApplicationAbility
    def initialize
      super
      cannot %i[duplicate update destroy], ::DataCleaning.internal
    end
  end
end
