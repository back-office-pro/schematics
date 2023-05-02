# frozen_string_literal: true

PaperTrail.request(enabled: false) do # rubocop:disable Metrics/BlockLength
  Core::Role.create!(
    name_en: 'Admin',
    name_fr: 'Administrateur',
    permissions: Core::Permission.create_all_entities_permissions!
  )
  Core::Role.create!(
    name_en: 'User',
    name_fr: 'Utilisateur',
    permissions: Core::Permission.features
  )
  Core::Configuration.instance.update!(locale: Tenant.customer_locale)
  Core::User.create!(
    email: Tenant.customer_email,
    password: Tenant.customer_password,
    role: Core::Role.admin
  )
  Core::Stat.create!(agregate: 'count', model: 'User')
  Core::Stat.create!(
    agregate: 'sum',
    model: 'ActiveStorage::Blob',
    field: 'ActiveStorage::Blob#byte_size'
  )
  Core::Chart.create!(
    kind: 'column',
    agregate: 'count',
    model: 'Core::Meeting',
    x_field: 'Core::Meeting#created_at/month'
  )
  Core::Chart.create!(
    kind: 'column',
    agregate: 'count',
    model: 'Core::Task',
    x_field: 'Core::Task#created_at/month'
  )
end
