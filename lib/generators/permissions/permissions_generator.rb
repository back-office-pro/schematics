# frozen_string_literal: true

class PermissionsGenerator < Rails::Generators::NamedBase
  class_option :rename, type: :string

  def generate_permissions
    return unless generating?

    Permission.reload_definitions!
    PaperTrail.request(enabled: false) do
      Role.admin.permissions.push(Permission.create_entity_permissions!(entity))
    end
  end

  def destroy_permissions
    return unless destroying?

    PaperTrail.request(enabled: false) do
      Permission.delete_by(model:)
      Schematics::Version.destroy_by(item_type: model)
      model_classes_with(model).each(&:destroy_all)
    end
  end

  def rename_permissions
    return unless renaming?

    PaperTrail.request(enabled: false) do
      Schematics::Version
        .where(item_type: old_model)
        .update_all(item_type: model) # rubocop:disable Rails/SkipsModelValidations
      model_classes_with(old_model)
        .each_with_object(model:)
        .each(&:update_all)
    end
  end

  private

  def entity = Tenant
    .schema
    .find_entity_by_name(name.underscore)

  def model = entity.class_name

  def old_model = options[:rename]

  def generating?
    behavior == :invoke && !old_model
  end

  def destroying?
    behavior == :revoke
  end

  def renaming?
    behavior == :invoke && old_model
  end

  def model_classes_with(model)
    Tenant
      .schema
      .entities
      .flat_map(&:model_attributes)
      .map(&:entity)
      .map(&:model_class)
      .uniq
      .each_with_object(model:)
      .map(&:where)
  end
end
