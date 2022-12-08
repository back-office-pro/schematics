# frozen_string_literal: true

module Schematics
  class VersionAbility < ApplicationAbility
    def initialize(user, mod)
      super
      can(:revert, Version, user:)
      cannot :revert, Version, object: nil
      user
        .role
        .permissions
        .each { can :read, Version, event: _1.action, item_type: _1.model }
    end
  end
end
