# frozen_string_literal: true

PaperTrail.request(enabled: false) do # rubocop:disable Metrics/BlockLength
  Role.create!(
    name_en: 'Admin',
    name_fr: 'Administrateur',
    name_it: 'Amministratore',
    permissions: Permission.create_entities_permissions!
  )
  Role.create!(
    name_en: 'User',
    name_fr: 'Utilisateur',
    name_it: 'Utente',
    permissions: Permission.features
  )
  Configuration.instance.update!(
    available_locales: I18n.available_locales.map(&:to_s),
    locale: Tenant.customer_locale
  )
  Documentation.create!
  User.create!(email: Tenant.customer_email, password: Tenant.customer_password, role: Role.admin)
  Stat.create!(aggregate: 'count', model: 'User')
  Stat.create!(
    aggregate: 'sum',
    model: 'ActiveStorage::Blob',
    field: 'ActiveStorage::Blob#byte_size'
  )
  Chart.new(
    kind: 'bar',
    aggregate: 'average',
    model: 'ApiRequest',
    x_field: 'ApiRequest#endpoint',
    y_field: 'ApiRequest#response_time'
  ).save(validate: false) # rubocop:disable Rails/SaveBang
  Chart.create!(
    kind: 'column',
    aggregate: 'count',
    model: 'Meeting',
    x_field: 'Meeting#created_at/month'
  )
  Chart.create!(
    kind: 'column',
    aggregate: 'count',
    model: 'Task',
    x_field: 'Task#created_at/month'
  )
end
