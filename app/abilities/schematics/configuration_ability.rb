# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class ConfigurationAbility < ApplicationAbility
    def initialize(user, mod)
      super
      return unless user.admin?

      can %i[show update], mod::Configuration
    end
  end
end
