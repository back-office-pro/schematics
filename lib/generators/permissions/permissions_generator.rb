# frozen_string_literal: true

class PermissionsGenerator < Rails::Generators::NamedBase
  def generate_permissions
    case behavior
    in :revoke
      PaperTrail.request(enabled: false) do
        ::Permission.destroy_by(model:)
        ::Chart.destroy_by(model:)
        ::Stat.destroy_by(model:)
        Schematics::Version.destroy_by(item_type: model)
      end
    in :invoke
      ::Rails.application.reloader.reload!
      PaperTrail.request(enabled: false) do
        ::Role.admin.permissions.push(::Permission.create_entity_permissions!(entity))
      end
    in :reinvoke
      PaperTrail.request(enabled: false) do
        # rubocop:disable Rails/SkipsModelValidations
        ::Permission.where(model:).update_all(model: new_model)
        ::Chart.where(model:).update_all(model: new_model)
        ::Stat.where(model:).update_all(model: new_model)
        Schematics::Version.where(item_type: model).update_all(item_type: new_model)
        # rubocop:enable Rails/SkipsModelValidations
      end
    end
  end

  private

  def entity = Schematics::Schema
    .instance
    .find_entity_by_name(name.underscore)

  def model = entity.class_name
end
