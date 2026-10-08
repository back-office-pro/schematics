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

    def initialize(ability)
      super
      return if MODEL_CLASSES.all? { ability.cannot?(:index, it.constantize) } &&
                ability.cannot?(:update, ::Configuration) &&
                ability.cannot?(:show, ::Chart.api)

      can :index, :admin
    end
  end
end
