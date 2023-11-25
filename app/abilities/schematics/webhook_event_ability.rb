# frozen_string_literal: true

module Schematics
  class WebhookEventAbility < ApplicationAbility
    def initialize(user)
      super
      return unless user.admin?

      can :read, ::WebhookEvent
    end
  end
end
