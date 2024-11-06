# frozen_string_literal: true

module Schematics
  class TeamAbility < ApplicationAbility
    def initialize(user)
      super
      model_classes.each do |model_class|
        cannot :read, model_class.where.associated(:teams) do |object|
          !object.teams.intersect?(user.teams)
        end
      end
    end

    private

    def model_classes = ::Tenant
      .schema
      .entities
      .flat_map(&:has_and_belongs_to_many_associations)
      .select { _1.model_class == ::Team }
      .map(&:entity)
      .filter_map(&:model_class)
  end
end
