# frozen_string_literal: true

module Schematics
  class DataCleaningAbility < ApplicationAbility
    def initialize
      super
      cannot :duplicate, ::DataCleaning
      cannot %i[update destroy], ::DataCleaning.internal
    end
  end
end
