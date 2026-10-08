# frozen_string_literal: true

module Schematics
  class PermissionAbility < ApplicationAbility
    def initialize(user)
      super

      user
        .role
        .permissions
        .select { Object.const_defined?(it.model) }
        .each { can it.action.to_sym, it.model.constantize }
    end
  end
end
