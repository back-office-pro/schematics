# frozen_string_literal: true

module Schematics
  class PermissionAbility < ApplicationAbility
    def initialize(user, mod)
      super
      user
        .role
        .permissions
        .select { mod.const_defined?(_1.model) }
        .each { can _1.action.to_sym, _1.model.constantize }
    end
  end
end
