# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class DemoAbility < ApplicationAbility
    def initialize(mod)
      super
      cannot %i[destroy archive], mod::User, role: mod::Role.admin
      cannot :update, mod::User, %i[password password_confirmation email], role: mod::Role.admin
    end
  end
end
