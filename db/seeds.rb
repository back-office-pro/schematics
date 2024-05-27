# frozen_string_literal: true

PaperTrail.request(enabled: false) do # rubocop:disable Metrics/BlockLength
  Role.create!(
    name_en: 'Admin',
    name_fr: 'Administrateur',
    name_it: 'Amministratore',
    permissions: Permission.create_entities_permissions!
  )
  Role.create!(
    name_en: 'Collaborator',
    name_fr: 'Collaborateur',
    name_it: 'Collaboratore',
    permissions: Permission.features
  )
  Configuration.instance.update!(
    available_locales: [Subscription.default_locale],
    locale: Subscription.default_locale
  )
  Documentation.create!
  Migration.default.save!
  User.create!(email: Subscription.email, password: Tenant.default_password, role: Role.admin)
  Stat.create!(aggregate: 'count', model: 'User')
  Stat.create!(aggregate: 'count', model: 'Emailing')
  Stat.create!(
    aggregate: 'sum',
    model: 'ActiveStorage::Blob',
    field: 'ActiveStorage::Blob#byte_size'
  )
  Chart.new(
    kind: 'bar',
    aggregate: 'average',
    model: 'APIRequest',
    x_field: 'APIRequest#endpoint',
    y_field: 'APIRequest#response_time'
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
