# frozen_string_literal: true

module Schematics
  class ApplicationAbility
    include CanCan::Ability

    def initialize(*)
      alias_action :duplicate, :import, to: :create
      alias_action :restore, to: :archive
      alias_action :delete, to: :destroy
    end

    def disallowed_params(action, subject)
      relevant_rules(action, subject)
        .select { it.matches_conditions?(action, subject) }
        .reject(&:base_behavior)
        .flat_map(&:attributes)
    end
  end
end
