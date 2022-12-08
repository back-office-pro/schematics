# frozen_string_literal: true

module Schematics
  class ApiRequestAbility < ApplicationAbility
    def initialize(user, mod)
      super
      return unless user.admin?

      can :read, mod::ApiRequest
    end
  end
end
