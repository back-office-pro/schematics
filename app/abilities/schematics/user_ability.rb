# frozen_string_literal: true

module Schematics
  class UserAbility < ApplicationAbility
    def initialize(user, mod)
      super
      cannot %i[destroy archive], user
      cannot :update, user, :role_id
      return unless user.admin?

      can :read, :admin_dashboard
      can :impersonate, mod::User
      can :update, mod::Licence
      cannot :impersonate, mod::User, role: mod::Role.admin
    end
  end
end
