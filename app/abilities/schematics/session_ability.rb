# frozen_string_literal: true

module Schematics
  class SessionAbility < ApplicationAbility
    def initialize(user)
      super
      return unless user.admin?

      can %i[create read destroy], ::Session
    end
  end
end
