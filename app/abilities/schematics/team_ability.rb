# frozen_string_literal: true

module Schematics
  class TeamAbility < ApplicationAbility
    def initialize(user, schema)
      super
      schema
        .entities
        .flat_map(&:has_and_belongs_to_many_associations)
        .select { it.model_class == ::Team }
        .map(&:entity)
        .filter_map(&:model_class)
        .each do |model_class|
          cannot :read, model_class.where.associated(:teams) do |object|
            !object.teams.intersect?(user.teams)
          end
        end
    end
  end
end
