# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class DataCleaningAbility < ApplicationAbility
    def initialize(mod)
      super
      cannot :duplicate, mod::DataCleaning
      cannot %i[update destroy], mod::DataCleaning.internal
    end
  end
end
