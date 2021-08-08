# frozen_string_literal: true

PaperTrail.enabled = false
admin_role = Role.create(name: 'Admin')
User.create(email: 'maxence.derous@gmail.com',
            password: 'Azerty1!',
            first_name: 'Maxence',
            last_name: 'De Rous',
            role: admin_role)
Setting.instance.update(company_name: Rails.application.class.module_parent_name)
Schematics::Schema.instance.entities.map(&:class_name).each do |model|
  Permission.actions.each_key do |action|
    admin_role.permissions << Permission.create(model: model, action: action)
  end
end
PaperTrail.enabled = true
