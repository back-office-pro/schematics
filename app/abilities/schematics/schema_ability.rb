# frozen_string_literal: true

module Schematics
  class SchemaAbility < ApplicationAbility
    def initialize(user)
      super
      return unless user.admin?

      can :update, Schema
    end
  end
end
