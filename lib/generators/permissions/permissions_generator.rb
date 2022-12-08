# frozen_string_literal: true

class PermissionsGenerator < Rails::Generators::NamedBase
  class_option :rename, type: :string

  def generate_permissions
    return unless generating?

    PaperTrail.request(enabled: false) do
      include tenant.mod
      Permission.reload_definitions!
      Role.admin.permissions.push(Permission.create_entity_permissions!(entity))
    end
  end

  def destroy_permissions
    return unless destroying?

    PaperTrail.request(enabled: false) do
      include tenant.mod
      Permission.destroy_by(model:)
      Chart.destroy_by(model:)
      Stat.destroy_by(model:)
      Schematics::Version.destroy_by(item_type: model)
    end
  end

  def rename_permissions
    return unless renaming?

    # rubocop:disable Rails/SkipsModelValidations
    PaperTrail.request(enabled: false) do
      include tenant.mod
      Permission.where(model: old_model).update_all(model:)
      Chart.where(model: old_model).update_all(model:)
      Stat.where(model: old_model).update_all(model:)
      Schematics::Version.where(item_type: old_model).update_all(item_type: model)
    end
    # rubocop:enable Rails/SkipsModelValidations
  end

  private

  def tenant = Schematics::Tenant.new(name: tenant_name)

  def tenant_name = name.split('/').first

  def entity = tenant
    .schema
    .find_entity_by_name(entity_name)

  def entity_name = name.split('/').second

  def model = entity.class_name

  def old_model = options[:rename]

  # :reek:NilCheck
  def generating?
    behavior == :invoke && old_model.nil?
  end

  def destroying?
    behavior == :revoke
  end

  def renaming?
    behavior == :invoke && old_model.present?
  end
end
