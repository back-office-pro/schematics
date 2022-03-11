# frozen_string_literal: true

module Schematics
  class VersionAbility < ApplicationAbility
    def initialize(user)
      super
      can(:revert, Version, user:)
      cannot :revert, Version, object: nil
      user.role.permissions.each do |permission|
        can :read, Version, event: permission.action, item_type: permission.model
      end
    end
  end
end
