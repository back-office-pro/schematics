# frozen_string_literal: true

module Schematics
  class UserGroupAbility < ApplicationAbility
    def initialize(user)
      super
      return if user.user_groups.empty?

      cannot :manage,
             model_classes,
             user_groups: { id: ::UserGroup.excluding(user.user_groups).ids }
    end

    private

    def model_classes = ::Tenant
      .schema
      .entities
      .flat_map(&:has_and_belongs_to_many_associations)
      .select { _1.association_type == ::UserGroup.entity.name }
      .map(&:model_class)
  end
end
