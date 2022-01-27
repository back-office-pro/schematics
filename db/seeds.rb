# frozen_string_literal: true

PaperTrail.enabled = false
Setting.instance.update_columns( # rubocop:disable Rails/SkipsModelValidations
  company_name: Rails.application.class.module_parent_name,
  theme_color: Rails.configuration.theme_color
)
Schematics::Schema.instance.entities.each do |entity|
  Permission
    .actions
    .keys
    .select(&entity.method(:can?))
    .each do |action|
      Role
        .find_or_create_by!(name: 'Admin')
        .permissions
        .push(Permission.find_or_create_by!(model: entity.class_name, action:))
    end
end
PaperTrail.enabled = true
