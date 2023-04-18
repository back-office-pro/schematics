# frozen_string_literal: true

module Schematics
  class AdminDashboardAbility < ApplicationAbility
    ADMIN_MODEL_CLASSES = [
      ::ApiKey,
      ::ApiRequest,
      ::Article,
      ::Permission,
      ::SchemaDataset,
      ::Session,
      ::Translation,
      ::Chart,
      ::Stat,
      ::User,
      ::UserGroup,
      ::Role,
      ::Configuration,
      ::Licence
    ].freeze

    def initialize(ability)
      super
      return if ADMIN_MODEL_CLASSES.all? { ability.cannot?(:index, _1) }

      can :read, :admin_dashboard
    end
  end
end
