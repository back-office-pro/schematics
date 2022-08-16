# frozen_string_literal: true

class PermissionsGenerator < Rails::Generators::NamedBase
  def generate_permissions
    if destroying?
      PaperTrail.request(enabled: false) do
        ::Permission.destroy_by(model:)
        ::Chart.destroy_by(model:)
        ::Stat.destroy_by(model:)
        Schematics::Version.destroy_by(item_type: model)
      end
    else
      ::Rails.application.reloader.reload!
      PaperTrail.request(enabled: false) do
        ::Role.admin.permissions.push(::Permission.create_entity_permissions!(entity))
      end
    end
  end

  private

  def destroying?
    behavior == :revoke
  end

  def entity = Schematics::Schema
    .instance
    .find_entity_by_name(name.underscore)

  def model = entity.class_name
end
