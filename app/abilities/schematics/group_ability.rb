# frozen_string_literal: true

module Schematics
  class GroupAbility < ApplicationAbility
    def initialize(user)
      super
      return if user.groups.empty?

      cannot :manage, [::Task, ::Meeting], groups: { id: Group.excluding(user.groups) }
    end
  end
end
