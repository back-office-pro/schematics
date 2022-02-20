# frozen_string_literal: true

module Schematics
  class Ability
    include CanCan::Ability
    attr_reader :user

    def initialize(user)
      @user = user
      aliases
      return unless @user

      user_permissions
      active_storage_attachment_permissions
      version_permissions
      references_attributes_restrictions
      default_restrictions
      licence_restrictions
    end

    def licence
      @licence ||= ::Licence.instance
    end

    private

    def admin?
      @user.role == ::Role.admin
    end

    def aliases
      alias_action :trigger, to: :update
      alias_action :import, to: :create
      alias_action :restore, to: :archive
      alias_action :delete, to: :destroy
    end

    def default_restrictions
      cannot %i[destroy archive], user
      cannot :update, user, :role_id
      cannot %i[update destroy archive], ::Role.admin
      cannot %i[show update destroy archive import], ::Message
      can :show, ::Message, recipient: user
      can :show, ::Message, author: user
      cannot :destroy, ActiveStorage::Attachment, { record_type: 'Import' }
    end

    def licence_restrictions
      cannot :create, ::User if licence.quota_users_exceeded?
      cannot :create, ActiveStorage::Attachment if licence.quota_storage_exceeded?
      cannot :manage, :all if licence.expired?
    end

    def user_permissions
      can :read, :admin_dashboard if admin?
      @user.role.permissions.each do |permission|
        can permission.action.to_sym, permission.model.constantize
      end
    end

    def active_storage_attachment_permissions
      @user
        .role
        .permissions
        .map(&:model)
        .uniq
        .filter { |model| can?(:update, model.constantize) }
        .each   { |model| can(:destroy, ActiveStorage::Attachment, record_type: model) }
    end

    def version_permissions
      can(:revert, Version, user:)
      @user.role.permissions.each do |permission|
        can :read, Version, event: permission.action, item_type: permission.model
      end
    end

    def references_attributes_restrictions
      Schema.instance.entities.flat_map(&:references_attributes).each do |attribute|
        model_class = attribute.entity.class_name.constantize
        cannot attribute.entity.actions, model_class
        can attribute.entity.actions, model_class, attribute.column_name => @user.id
      end
    end
  end
end
