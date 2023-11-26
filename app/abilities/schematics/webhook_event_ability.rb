# frozen_string_literal: true

module Schematics
  class WebhookEventAbility < ApplicationAbility
    def initialize(user)
      super
      return unless user.admin?

      can %i[read retry], ::WebhookEvent
    end
  end
end
