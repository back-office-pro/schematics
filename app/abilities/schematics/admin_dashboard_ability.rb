# frozen_string_literal: true

module Schematics
  class AdminDashboardAbility < ApplicationAbility
    ADMIN_MODEL_CLASSES = [
      Core::ApiKey,
      Core::ApiRequest,
      Core::Permission,
      Core::SchemaDataset,
      Core::Session,
      Core::Translation,
      Core::Chart,
      Core::Stat,
      Core::User,
      Core::UserGroup,
      Core::Role,
      Core::Configuration,
      Core::Licence
    ].freeze

    def initialize(ability)
      super
      return if ADMIN_MODEL_CLASSES.all? { ability.cannot?(:index, _1) }

      can :read, :admin_dashboard
    end
  end
end
