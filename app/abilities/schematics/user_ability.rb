# frozen_string_literal: true

module Schematics
  class UserAbility < ApplicationAbility
    def initialize(user)
      super
      cannot %i[destroy archive], user
      cannot :update, user, :role_id
    end
  end
end
