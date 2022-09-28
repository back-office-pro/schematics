# frozen_string_literal: true

PaperTrail.request(enabled: false) do
  Role.create!(name: 'Admin', permissions: Permission.create_all_entities_permissions!)
  User.create!(email: Schematics::Licence.email, role: Role.admin)
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
