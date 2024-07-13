# frozen_string_literal: true

PaperTrail.request(enabled: false) do # rubocop:disable Metrics/BlockLength
  Role.create!(
    [
      {
        name_en: 'Admin',
        name_fr: 'Administrateur',
        name_it: 'Amministratore',
        permissions: Permission.create_entities_permissions!
      },
      {
        name_en: 'Collaborator',
        name_fr: 'Collaborateur',
        name_it: 'Collaboratore',
        permissions: Permission.features
      }
    ]
  )
  Configuration.instance.update!(
    available_locales: [Subscription.default_locale],
    locale: Subscription.default_locale
  )
  Documentation.create!
  Migration.default.save!
  User.create!(email: Subscription.email, password: Tenant.default_password, role: Role.admin)
  Metric.create!(
    [
      {
        aggregate: 'count',
        model: 'Emailing'
      },
      {
        aggregate: 'count',
        model: 'User',
        comparator: 'greater_than_or_equal_to',
        threshold: Subscription.quota_users,
        roles: [Role.admin]
      },
      {
        aggregate: 'count',
        model: 'APIKey',
        comparator: 'greater_than_or_equal_to',
        threshold: Subscription.quota_api_keys,
        roles: [Role.admin]
      },
      {
        aggregate: 'sum',
        model: 'ActiveStorage::Blob',
        field: 'ActiveStorage::Blob#byte_size',
        comparator: 'greater_than_or_equal_to',
        threshold: Subscription.quota_storage,
        roles: [Role.admin]
      }
    ]
  )
  Chart.new(
    kind: 'bar',
    aggregate: 'average',
    model: 'APIRequest',
    x_field: 'APIRequest#endpoint',
    y_field: 'APIRequest#response_time'
  ).save(validate: false) # rubocop:disable Rails/SaveBang
  Chart.create!(
    [
      { kind: 'column', aggregate: 'count', model: 'Meeting', x_field: 'Meeting#created_at/month' },
      { kind: 'column', aggregate: 'count', model: 'Task', x_field: 'Task#created_at/month' }
    ]
  )
  DataCleaning
    .new(model: 'Comparison', period: 'month', really_destroy: true)
    .save(validate: false) # rubocop:disable Rails/SaveBang
  %w[APIRequest Draft Search Session].each do |model|
    DataCleaning
      .new(model:, period: 'year', really_destroy: true)
      .save(validate: false)
  end
  DataCleaning.create!(
    [
      { model: 'APIKey', field: 'APIKey#expires_at', period: 'year' },
      { model: 'Meeting', field: 'Meeting#end_at', period: 'year' },
      { model: 'Import', period: 'year' }
    ]
  )
end
