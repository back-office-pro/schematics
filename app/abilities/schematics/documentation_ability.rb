# frozen_string_literal: true

module Schematics
  class DocumentationAbility < ApplicationAbility
    def initialize(user, mod)
      super
      return unless user.admin?

      can :show, mod::Documentation
    end
  end
end
