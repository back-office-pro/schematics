# frozen_string_literal: true

module Schematics
  class WebhookRequestAbility < ApplicationAbility
    def initialize(user)
      super
      return unless user.admin?

      can %i[read retry], ::WebhookRequest
    end
  end
end
