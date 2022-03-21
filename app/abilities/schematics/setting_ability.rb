# frozen_string_literal: true

module Schematics
  class SettingAbility < ApplicationAbility
    def initialize(user)
      super
      return unless user.role == ::Role.admin

      can :update, ::Setting
      can :show, ::Setting
    end
  end
end
