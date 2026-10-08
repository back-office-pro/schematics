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
  Configuration.instance.save!
  Documentation.create!
  User.create!(
    email: 'support@back-office.pro',
    password: Schematics::Attributes::Digest::DEFAULT,
    role: Role.admin
  )
  Dashboard.create!(
    [
      {
        title_en: 'Admin dashboard',
        title_fr: 'Tableau de bord administrateur',
        title_it: 'Cruscotto amministratore',
        roles: [Role.admin]
      },
      {
        title_en: 'Global dashboard',
        title_fr: 'Tableau de bord global',
        title_it: 'Cruscotto globale'
      }
    ]
  )
  Ranking.create!(
    model: 'ActiveStorage::Blob',
    field: 'ActiveStorage::Blob#byte_size',
    dashboards: [Dashboard.first]
  )
  Metric.create!(
    [
      {
        aggregate: 'count',
        model: 'Emailing',
        dashboards: Dashboard.all
      },
      {
        aggregate: 'count',
        model: 'User',
        comparator: 'greater_than_or_equal_to',
        threshold: Schematics::License::QUOTA[:USERS],
        dashboards: [Dashboard.first]
      },
      {
        aggregate: 'count',
        model: 'APIKey',
        comparator: 'greater_than_or_equal_to',
        threshold: Schematics::License::QUOTA[:API_KEYS],
        dashboards: [Dashboard.first]
      },
      {
        aggregate: 'sum',
        model: 'ActiveStorage::Blob',
        field: 'ActiveStorage::Blob#byte_size',
        comparator: 'greater_than_or_equal_to',
        threshold: Schematics::License::QUOTA[:STORAGE],
        dashboards: [Dashboard.first]
      }
    ]
  )
  Chart.create_without_validations(
    [
      {
        kind: 'bar',
        aggregate: 'average',
        model: 'APIRequest',
        x_field: 'APIRequest#endpoint',
        y_field: 'APIRequest#response_time',
        period: 'month'
      },
      {
        kind: 'column',
        aggregate: 'count',
        model: 'Meeting',
        x_field: 'Meeting#created_at/month',
        dashboards: Dashboard.all
      },
      {
        kind: 'column',
        aggregate: 'count',
        model: 'Task',
        x_field: 'Task#created_at/month',
        dashboards: Dashboard.all
      }
    ]
  )
  DataCleaning.create_without_validations(
    [
      { model: 'Backup', period: 'week', really_destroy: true },
      { model: 'LinkPreview', period: 'week', really_destroy: true },
      { model: 'Comparison', period: 'month', really_destroy: true },
      { model: 'APIRequest', period: 'year', really_destroy: true },
      { model: 'Draft', period: 'year', really_destroy: true },
      { model: 'Search', period: 'year', really_destroy: true },
      { model: 'Session', period: 'year', really_destroy: true },
      { model: 'APIKey', period: 'year', field: 'APIKey#expires_at' },
      { model: 'Meeting', period: 'year', field: 'Meeting#end_at' },
      { model: 'Import', period: 'year' }
    ]
  )
end
