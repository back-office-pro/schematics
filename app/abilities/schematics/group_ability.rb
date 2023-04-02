# frozen_string_literal: true

module Schematics
  class GroupAbility < ApplicationAbility
    def initialize(user)
      super
      return if user.groups.empty?

      cannot :manage, model_classes, groups: { id: ::Group.excluding(user.groups) }
    end

    private

    def model_classes = ::Tenant
      .schema
      .entities
      .select { |entity| entity.has_and_belongs_to_many_associations.any? { _1.name == 'groups' } }
      .map(&:model_class)
  end
end
