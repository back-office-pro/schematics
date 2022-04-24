# frozen_string_literal: true

module Schematics
  class SessionAbility < ApplicationAbility
    def initialize(user)
      super
      can(:destroy, ::Session, user:)
      return unless user.role == ::Role.admin

      can %i[read destroy], ::Session
    end
  end
end
