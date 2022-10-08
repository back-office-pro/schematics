# frozen_string_literal: true

module Schematics
  class ApiRequestAbility < ApplicationAbility
    def initialize(user)
      super
      return unless user.admin?

      can :read, ::ApiRequest
    end
  end
end
