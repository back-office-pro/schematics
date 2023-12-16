# frozen_string_literal: true

module Schematics
  class UserGroupAbility < ApplicationAbility
    def initialize(user)
      super
      model_classes.each do |model_class|
        cannot :read, model_class.where.associated(:user_groups) do |object|
          !object.user_groups.intersect?(user.user_groups)
        end
      end
    end

    private

    def model_classes = ::Tenant
      .schema
      .entities
      .flat_map(&:has_and_belongs_to_many_associations)
      .select { _1.model_class == ::UserGroup }
      .map(&:entity)
      .filter_map(&:model_class)
  end
end
