PaperTrail.enabled = false
admin_role = Role.create!(name: 'Admin')
User.create!(email: 'admin@admin.com',
             password: '123456',
             first_name: 'Jean',
             last_name: 'Dupont',
             role: admin_role)
Setting.instance.update(company_name: Rails.application.class.module_parent_name, theme: 'flatly')
Schematics::SCHEMA.entities.map(&:class_name).each do |model|
  Permission.actions.keys.each do |action|
    permission = Permission.create!(model: model, action: action)
    RolePermission.create(role: admin_role, permission: permission)
  end
end
PaperTrail.enabled = true
