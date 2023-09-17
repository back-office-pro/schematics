# frozen_string_literal: true

class PermissionGenerator < Rails::Generators::NamedBase
  class_option :action, type: :string
  class_option :rename, type: :string

  def generate_permission
    return unless generating?

    Permission.reload_definitions!
    PaperTrail.request(enabled: false) do
      Role.admin.permissions.push(Permission.create!(model:, action:))
    end
  end

  def destroy_permission
    return unless destroying?

    PaperTrail.request(enabled: false) do
      Permission.destroy_by(model:, action:)
    end
  end

  def rename_permission
    return unless renaming?

    PaperTrail.request(enabled: false) do
      Permission.where(model:, action: old_action).update!(action:)
    end
  end

  private

  def entity = ::Tenant
    .schema
    .find_entity_by_name(name.underscore)

  def model = entity.class_name

  def action = options[:action]

  def old_action = options[:rename]

  def generating?
    behavior == :invoke && !old_action
  end

  def destroying?
    behavior == :revoke
  end

  def renaming?
    behavior == :invoke && old_action
  end
end
