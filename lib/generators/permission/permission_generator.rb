# frozen_string_literal: true

class PermissionGenerator < Rails::Generators::NamedBase
  class_option :action, type: :string
  class_option :rename, type: :string

  def generate_permission
    return unless generating?

    Core::Permission.reload_definitions!
    PaperTrail.request(enabled: false) do
      Role.admin.permissions.push(Core::Permission.create!(model:, action:))
    end
  end

  def destroy_permission
    return unless destroying?

    PaperTrail.request(enabled: false) do
      Core::Permission.destroy_by(model:, action:)
    end
  end

  def rename_permission
    return unless renaming?

    PaperTrail.request(enabled: false) do
      Core::Permission.where(model:, action: old_action).update!(action:)
    end
  end

  private

  def entity = ::Tenant
    .schema
    .find_entity_by_name(name.underscore)

  def model = entity.class_name

  def action = options[:action]

  def old_action = options[:rename]

  # :reek:NilCheck
  def generating?
    behavior == :invoke && old_action.nil?
  end

  def destroying?
    behavior == :revoke
  end

  def renaming?
    behavior == :invoke && old_action.present?
  end
end
