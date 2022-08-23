# frozen_string_literal: true

class PermissionsGenerator < Rails::Generators::NamedBase
  class_option :rename, type: :string

  def generate_permissions
    return unless behavior == :invoke

    ::Rails.application.reloader.reload!
    PaperTrail.request(enabled: false) do
      ::Role.admin.permissions.push(::Permission.create_entity_permissions!(entity))
    end
  end

  def destroy_permissions
    return unless behavior == :revoke

    PaperTrail.request(enabled: false) do
      ::Permission.destroy_by(model:)
      ::Chart.destroy_by(model:)
      ::Stat.destroy_by(model:)
      Schematics::Version.destroy_by(item_type: model)
    end
  end

  def rename_permissions
    return unless behavior == :reinvoke

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

  def entity = Schematics::Schema
    .instance
    .find_entity_by_name(name.underscore)

  def model = entity.class_name

  def old_model = options[:rename]
end
