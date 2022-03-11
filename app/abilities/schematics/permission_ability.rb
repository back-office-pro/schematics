# frozen_string_literal: true

module Schematics
  class PermissionAbility < ApplicationAbility
    def initialize(user)
      super
      can :read, :admin_dashboard if user.role == ::Role.admin
      user.role.permissions.each do |permission|
        can permission.action.to_sym, permission.model.constantize
      end
      Schema.instance.entities.flat_map(&:references_attributes).each do |attribute|
        model_class = attribute.entity.class_name.constantize
        cannot attribute.entity.actions, model_class
        can attribute.entity.actions, model_class, attribute.column_name => user.id
      end
    end
  end
end
