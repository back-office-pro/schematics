# frozen_string_literal: true

module Schematics
  class DocumentationAbility < ApplicationAbility
    def initialize(user)
      super
      return unless user.admin?

      can :show, ::Documentation
    end
  end
end
