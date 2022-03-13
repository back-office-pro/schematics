# frozen_string_literal: true

module Schematics
  class PermissionAbility < ApplicationAbility
    def initialize(user)
      super
      user
        .role
        .permissions
        .select { Object.const_defined?(_1.model) }
        .each { can _1.action.to_sym, _1.model.constantize }
      Schema
        .instance
        .entities
        .flat_map(&:references_attributes)
        .select { Object.const_defined?(_1.entity.class_name) }
        .each do |attribute|
          cannot attribute.entity.actions, attribute.entity.model_class
          can attribute.entity.actions,
              attribute.entity.model_class,
              attribute.column_name => user.id
        end
    end
  end
end
