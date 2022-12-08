# frozen_string_literal: true

tenant = Schematics::Tenant.new

PaperTrail.request(enabled: false) do
  include tenant.mod
  Role.create!(name: 'Admin', permissions: Permission.create_all_entities_permissions!)
  Role.create!(name: 'Manager', permissions: Permission.features)
  Configuration.instance.update!(locale: tenant.customer_locale)
  User.create!(email: tenant.customer_email, role: Role.admin)
  Stat.create!(agregate: 'count', model: 'User')
  Stat.create!(
    agregate: 'sum',
    model: 'ActiveStorage::Attachment',
    field: 'ActiveStorage::Attachment#byte_size'
  )
  Chart.create!(
    kind: 'column',
    agregate: 'count',
    model: 'Meeting',
    x_field: 'Meeting#created_at/month'
  )
  Chart.create!(
    kind: 'column',
    agregate: 'count',
    model: 'Task',
    x_field: 'Task#created_at/month'
  )
end
