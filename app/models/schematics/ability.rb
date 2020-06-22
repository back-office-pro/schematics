module Schematics
  class Ability
    include CanCan::Ability
    attr_reader :user

    def initialize(user)
      @user = user
      aliases
      # TODO improve tests with role/permissions
      return can :manage, :all if Rails.env.test?
      user_abilities
      singleton_abilities
      reference_abilities
      default_abilities
    end

    def admin?
      @user.role == Role.last
    end

    private

    def aliases
      alias_action :autocomplete, to: :read
      alias_action :bulk_insert, to: :import
      alias_action :restore, to: :archive
    end

    def default_abilities
      cannot :manage, Permission
      cannot [:destroy, :archive], user
      cannot [:update, :destroy, :archive], Role.last
      can :read, Message, recipient_id: user.id
    end

    def user_abilities
      # TODO @user.permissions (has_and_belongs_to_many)
      @user.role.role_permissions.includes(:permission).map(&:permission).each do |permission|
        can permission.action.to_sym, permission.model.constantize
      end
    end

    def singleton_abilities
      SCHEMA.entities.select_is_a?(Entities::Singleton).each do |entity|
        cannot [:index, :create, :destroy, :archive], entity.class_name.constantize
      end
    end

    def reference_abilities
      SCHEMA.entities.map(&:references_attributes).flatten.each do |attribute|
        model_class = attribute.entity.class_name.constantize
        cannot [:read, :update, :destroy, :archive], model_class
        can [:read, :update, :destroy, :archive], model_class, attribute.column_name => @user.id
      end
    end
  end
end
