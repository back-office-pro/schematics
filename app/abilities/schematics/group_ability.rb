# frozen_string_literal: true

module Schematics
  class GroupAbility < ApplicationAbility
    def initialize(user)
      super
      return if user.groups.empty?

      cannot :manage, model_classes, groups: { id: ::Group.excluding(user.groups).ids }
    end

    private

    def model_classes = ::Tenant
      .schema
      .entities
      .flat_map(&:has_and_belongs_to_many_associations)
      .select { _1.name == ::Group.table_name }
      .map(&:model_class)
  end
end
