# frozen_string_literal: true

module Schematics
  class UserAbility < ApplicationAbility
    def initialize(user)
      super
      cannot %i[destroy archive], user
      can :update, user
      cannot :update, user, %i[role role_id user_groups user_group_ids]
      return unless user.admin?

      can :impersonate, Core::User
      cannot :impersonate, Core::User, role: Core::Role.admin
    end
  end
end
