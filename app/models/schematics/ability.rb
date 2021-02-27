module Schematics
  class Ability
    include CanCan::Ability
    attr_reader :user

    def initialize(user)
      @user = user
      aliases
      user_abilities
      singleton_abilities
      reference_abilities
      default_abilities
      can :manage, :all if Rails.env.test? # TODO: improve tests with role/permissions
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
      cannot %i[create update destroy import archive], Permission
      cannot %i[destroy archive], user
      cannot %i[update destroy archive], Role.last
      can :read, Message, recipient_id: user.id
    end

    def user_abilities
      @user.role.permissions.each do |permission|
        can permission.action.to_sym, permission.model.constantize
      end
    end

    def singleton_abilities
      SCHEMA.entities.select_is_a?(Entities::Singleton).each do |entity|
        cannot %i[index create destroy archive], entity.class_name.constantize
      end
    end

    def reference_abilities
      SCHEMA.entities.flat_map(&:references_attributes).each do |attribute|
        model_class = attribute.entity.class_name.constantize
        cannot %i[read update destroy archive], model_class
        can %i[read update destroy archive], model_class, attribute.column_name => @user.id
      end
    end
  end
end
