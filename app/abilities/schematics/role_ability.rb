# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class RoleAbility < ApplicationAbility
    def initialize(mod)
      super
      cannot %i[duplicate update destroy archive], mod::Role.admin
    end
  end
end
