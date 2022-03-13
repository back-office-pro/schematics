# frozen_string_literal: true

module Schematics
  class UserAbility < ApplicationAbility
    def initialize(user)
      super
      can :read, :admin_dashboard if user.role == ::Role.admin
      cannot %i[destroy archive], user
      cannot :update, user, :role_id
    end
  end
end
