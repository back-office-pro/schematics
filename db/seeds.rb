# frozen_string_literal: true

PaperTrail.request(enabled: false) do # rubocop:disable Metrics/BlockLength
  Role.create!(
    name_en: 'Admin',
    name_fr: 'Administrateur',
    permissions: Permission.create_entities_permissions!
  )
  Role.create!(
    name_en: 'User',
    name_fr: 'Utilisateur',
    permissions: Permission.features
  )
  Configuration.instance.update!(
    available_locales: I18n.available_locales.map(&:to_s),
    locale: Tenant.customer_locale
  )
  User.create!(email: Tenant.customer_email, password: Tenant.customer_password, role: Role.admin)
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
