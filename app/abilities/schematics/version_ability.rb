# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class VersionAbility < ApplicationAbility
    def initialize(user, mod)
      super
      can(:read, Version, event: 'mention', user:)
      can(:revert, Version, user:)
      cannot :revert, Version, object: nil
      cannot :revert, Version.where(item: mod::Migration.state_finished)
      user
        .role
        .permissions
        .each { can :read, Version, event: it.action, item_type: it.model }
    end
  end
end
