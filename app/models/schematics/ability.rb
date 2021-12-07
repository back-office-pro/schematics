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

    def admin?
      @user.role == admin_role
    end

    def licence
      @licence ||= LicenceDecorator.decorate(Licence.instance)
    end

    private

    def admin_role
      @admin_role ||= Role.find_by(name: 'Admin')
    end

    def aliases
      alias_action :import, to: :create
      alias_action :restore, to: :archive
      alias_action :delete, to: :destroy
    end

    def default_restrictions
      cannot %i[destroy archive], user
      cannot :update, user, :role_id
      cannot %i[update destroy archive], admin_role
      cannot %i[read update destroy archive import], Message
      can :read, Message, recipient_id: user.id
      can :read, Message, author_id: user.id
      can %i[update destroy archive], Message, { read_at: nil }
      cannot :destroy, ActiveStorage::Attachment, { record_type: 'Import' }
    end

    def licence_restrictions
      cannot :create, User if licence.quota_users_exceeded?
      cannot :create, ActiveStorage::Attachment if licence.quota_storage_exceeded?
      cannot :manage, :all if licence.expired?
    end

    def user_permissions
      @user.role.permissions.each do |permission|
        can permission.action.to_sym, permission.model.constantize
        can :autocomplete, permission.model.constantize if permission.action.to_sym == :index
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
      can :revert, Version, whodunnit: user.id
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
