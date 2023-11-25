# frozen_string_literal: true

module Schematics
  class AdminDashboardAbility < ApplicationAbility
    ADMIN_MODEL_CLASSES = [
      ::ApiKey,
      ::ApiRequest,
      ::Permission,
      ::Migration,
      ::Session,
      ::Translation,
      ::Chart,
      ::Stat,
      ::User,
      ::UserGroup,
      ::Role,
      ::Documentation
    ].freeze

    def initialize(ability)
      super
      return if ADMIN_MODEL_CLASSES.all? { ability.cannot?(:index, _1) } &&
                ability.cannot?(:cancel, ::Licence) &&
                ability.cannot?(:update, ::Configuration) &&
                ability.cannot?(:show, ::Chart.api)

      can :read, :admin_dashboard
    end
  end
end
