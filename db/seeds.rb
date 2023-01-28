# frozen_string_literal: true

PaperTrail.request(enabled: false) do
  Role.create!(name: 'Admin', permissions: Permission.create_all_entities_permissions!)
  Role.create!(name: 'Manager', permissions: Permission.features)
  Configuration.instance.update!(locale: Tenant.customer_locale)
  User.create!(email: Tenant.customer_email, role: Role.admin)
  Stat.create!(agregate: 'count', model: 'User')
  Stat.create!(
    agregate: 'sum',
    model: 'ActiveStorage::Blob',
    field: 'ActiveStorage::Blob#byte_size'
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
