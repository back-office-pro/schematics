# frozen_string_literal: true

module Schematics
  class UserAbility < ApplicationAbility
    def initialize(user)
      super
      cannot %i[destroy archive], user
      cannot :update, user, :role_id
      return unless user.admin?

      can :read, :admin_dashboard
      can :impersonate, ::User
      can :destroy, Licence # rubocop:disable Lint/ConstantResolution
      cannot :impersonate, ::User, role: ::Role.admin
    end
  end
end
