# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class DemoAbility < ApplicationAbility
    def initialize
      super
      cannot %i[destroy archive], ::User, role: ::Role.admin
      cannot :update, ::User, %i[password password_confirmation email], role: ::Role.admin
    end
  end
end
