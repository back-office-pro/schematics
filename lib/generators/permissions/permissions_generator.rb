# frozen_string_literal: true

class PermissionsGenerator < Rails::Generators::NamedBase
  class_option :rename, type: :string

  def generate_permissions
    return unless generating?

    ::Permission.reload_definitions!
    PaperTrail.request(enabled: false) do
      ::Role.admin.permissions.push(::Permission.create_entity_permissions!(entity))
    end
  end

  def destroy_permissions
    return unless destroying?

    PaperTrail.request(enabled: false) do
      ::Permission.destroy_by(model:)
      ::Chart.destroy_by(model:)
      ::Stat.destroy_by(model:)
      Schematics::Version.destroy_by(item_type: model)
    end
  end

  def rename_permissions
    return unless renaming?

    PaperTrail.request(enabled: false) do
      # rubocop:disable Rails/SkipsModelValidations
      ::Permission.where(model: old_model).update_all(model:)
      ::Chart.where(model: old_model).update_all(model:)
      ::Stat.where(model: old_model).update_all(model:)
      Schematics::Version.where(item_type: old_model).update_all(item_type: model)
      # rubocop:enable Rails/SkipsModelValidations
    end
  end

  private

  def entity = ::Tenant
    .current_schema
    .find_entity_by_name(name.underscore)

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
