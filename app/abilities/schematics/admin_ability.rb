# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class AdminAbility < ApplicationAbility
    MODEL_CLASSES = %w[
      APIKey
      APIRequest
      Permission
      Migration
      Session
      Translation
      Dashboard
      Chart
      Metric
      Ranking
      User
      Team
      Role
      Documentation
      WebhookRequest
      WebhookEndpoint
      PDFTemplate
      EmailTemplate
      DataCleaning
    ].freeze

    def initialize(ability, mod)
      super
      return if MODEL_CLASSES.all? { ability.cannot?(:index, it.constantize) } &&
                ability.cannot?(:cancel, mod::Subscription) &&
                ability.cannot?(:update, mod::Configuration) &&
                ability.cannot?(:show, mod::Chart.api)

      can :index, :admin
    end
  end
end
