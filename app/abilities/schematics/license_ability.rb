# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class LicenseAbility < ApplicationAbility
    def initialize
      super
      cannot %i[create restore update], :all unless License.active?
    end
  end
end
