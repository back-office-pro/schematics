# frozen_string_literal: true

module Schematics
  class AdminDashboardAbility < ApplicationAbility
    def initialize(ability) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      super
      return if ability.cannot?(:index, ::ApiKey) &&
                ability.cannot?(:index, ::ApiRequest) &&
                ability.cannot?(:index, ::Permission) &&
                ability.cannot?(:index, ::SchemaDataset) &&
                ability.cannot?(:index, ::Session) &&
                ability.cannot?(:index, ::Translation) &&
                ability.cannot?(:index, ::Chart) &&
                ability.cannot?(:index, ::Stat) &&
                ability.cannot?(:update, ::Configuration) &&
                ability.cannot?(:cancel, ::Licence)

      can :read, :admin_dashboard
    end
  end
end
