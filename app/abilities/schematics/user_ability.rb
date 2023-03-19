# frozen_string_literal: true

module Schematics
  class UserAbility < ApplicationAbility
    delegate :demo?, to: '::Tenant', private: true

    def initialize(user)
      super
      cannot %i[destroy archive], user
      cannot :update, user, :role_id
      cannot %i[update destroy archive], ::User, role: ::Role.admin if demo?
      return unless user.admin?

      can :impersonate, ::User
      cannot :impersonate, ::User, role: ::Role.admin
    end
  end
end
