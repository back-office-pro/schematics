# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class UserAbility < ApplicationAbility
    def initialize(user)
      super
      cannot %i[destroy archive], user
      can :update, user
      cannot :update, user, %i[role role_id teams team_ids]
      return unless user.admin?

      can :impersonate, ::User
      cannot :impersonate, ::User, role: ::Role.admin
    end
  end
end
