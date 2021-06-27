# frozen_string_literal: true

module Schematics
  class Ability
    include CanCan::Ability
    attr_reader :user

    def initialize(user)
      @user = user
      aliases
      return can :manage, :all if Rails.env.test? # rubocop:disable Lint/ReturnInVoidContext

      user_permissions
      active_storage_attachment_permissions
      version_permissions
      singleton_restrictions
      references_attributes_restrictions
      default_restrictions
    end

    def admin?
      @user.role == admin_role
    end

    private

    def admin_role
      @admin_role ||= Role.find_by(name: 'Admin')
    end

    def aliases
      alias_action :autocomplete, to: :read
      alias_action :import, to: :create
      alias_action :restore, to: :archive
      alias_action :delete, to: :destroy
    end

    def default_restrictions
      cannot %i[destroy archive], user
      cannot :update, user, :role_id
      cannot %i[update destroy archive], admin_role
      cannot %i[create update destroy archive], Permission
      cannot %i[read update destroy archive], Message
      cannot %i[create update destroy archive], Import
      cannot :import, [Directory, Message, Permission, Import]
      cannot %i[update archive], ActiveStorage::Attachment
      cannot :destroy, ActiveStorage::Attachment, { record_type: 'Import' }
      can :read, Message, recipient_id: user.id
      can :read, Message, author_id: user.id
      can %i[update destroy archive], Message, { read_at: nil }
    end

    def user_permissions
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
        .filter { |model| can?(:edit, model.constantize) }
        .each   { |model| can(:destroy, ActiveStorage::Attachment, { record_type: model }) }
    end

    def version_permissions
      can :revert, Version, whodunnit: user.id
      @user.role.permissions.each do |permission|
        can :read, Version,
            event: permission.action,
            item_type: permission.model
      end
    end

    def singleton_restrictions
      Schema.instance.entities.select_is_a?(Entities::Singleton).each do |entity|
        cannot %i[index create destroy archive import], entity.class_name.constantize
      end
    end

    def references_attributes_restrictions
      Schema.instance.entities.flat_map(&:references_attributes).each do |attribute|
        model_class = attribute.entity.class_name.constantize
        cannot %i[read update destroy archive], model_class
        can %i[read update destroy archive], model_class, attribute.column_name => @user.id
      end
    end
  end
end
