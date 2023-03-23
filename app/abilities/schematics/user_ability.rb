# frozen_string_literal: true

module Schematics
  class UserAbility < ApplicationAbility
    def initialize(user)
      super
      cannot %i[destroy archive], user
      cannot :update, user, %i[role role_id]
      can :update, user, :password_challenge
      return unless user.admin?

      can :impersonate, ::User
      cannot :impersonate, ::User, role: ::Role.admin
    end
  end
end
