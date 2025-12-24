# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class LicenseAbility < ApplicationAbility
    def initialize
      super
      return if ::Configuration.license_active?

      cannot :manage, :all
    end
  end
end
