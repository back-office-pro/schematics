# frozen_string_literal: true

class PermissionGenerator < Rails::Generators::NamedBase
  class_option :action, type: :string
  class_option :rename, type: :string

  def generate_permission
    return unless generating?

    reload_permission_definition!
    PaperTrail.request(enabled: false) do
      Role.admin.permissions.push(Permission.create!(model: name, action:))
    end
  end

  def destroy_permission
    return unless destroying?

    PaperTrail.request(enabled: false) do
      Permission.delete_by(model: name, action:)
    end
  end

  def rename_permission
    return unless renaming?

    PaperTrail.request(enabled: false) do
      Permission.where(model: name, action: old_action).update!(action:)
    end
  end

  private

  def generating?
    behavior == :invoke && !old_action
  end

  def old_action = options[:rename]

  def reload_permission_definition!
    Object.__send__(:remove_const, :Permission)
    load Schematics::Engine.root.join('app', 'models', 'core', 'permission.rb')
  end

  def action = options[:action]

  def destroying?
    behavior == :revoke
  end

  def renaming?
    behavior == :invoke && old_action
  end
end
