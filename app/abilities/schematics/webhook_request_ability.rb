# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class WebhookRequestAbility < ApplicationAbility
    def initialize(user, mod)
      super
      return unless user.admin?

      can %i[read retry], mod::WebhookRequest
    end
  end
end
