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
      Schematics::Version
        .where(item_type: model)
        .in_batches
        .destroy_all
      schema_model_attributes.each do |attribute|
        attribute
          .entity
          .model_class
          .where(attribute.name => model)
          .in_batches
          .destroy_all
      end
    end
  end

  def rename_permissions
    return unless renaming?

    PaperTrail.request(enabled: false) do
      Schematics::Version
        .where(item_type: old_model)
        .in_batches
        .update_all(item_type: model) # rubocop:disable Rails/SkipsModelValidations
      schema_model_attributes.each do |attribute|
        attribute
          .entity
          .model_class
          .where(attribute.name => old_model)
          .in_batches
          .update_all(attribute.name => model) # rubocop:disable Rails/SkipsModelValidations
      end
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

  def schema_model_attributes = Tenant
    .schema
    .entities
    .flat_map(&:model_attributes)
end
