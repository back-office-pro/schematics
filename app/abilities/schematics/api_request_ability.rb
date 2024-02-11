# frozen_string_literal: true

module Schematics
  class APIRequestAbility < ApplicationAbility
    def initialize(user)
      super
      return unless user.admin?

      can :read, ::APIRequest
    end
  end
end
