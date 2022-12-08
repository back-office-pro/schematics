# frozen_string_literal: true

PaperTrail.request(enabled: false) do
  tenant = Schematics::Tenant.new
  mod = tenant.mod
  mod::Role.create!(name: 'Admin', permissions: mod::Permission.create_all_entities_permissions!)
  mod::Role.create!(name: 'Manager', permissions: mod::Permission.features)
  mod::Configuration.instance.update!(locale: tenant.customer_locale)
  mod::User.create!(email: tenant.customer_email, role: mod::Role.admin)
  mod::Stat.create!(agregate: 'count', model: 'User')
  mod::Stat.create!(
    agregate: 'sum',
    model: 'ActiveStorage::Attachment',
    field: 'ActiveStorage::Attachment#byte_size'
  )
  mod::Chart.create!(
    kind: 'column',
    agregate: 'count',
    model: 'Meeting',
    x_field: 'Meeting#created_at/month'
  )
  mod::Chart.create!(
    kind: 'column',
    agregate: 'count',
    model: 'Task',
    x_field: 'Task#created_at/month'
  )
end
