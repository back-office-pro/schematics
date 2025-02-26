# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

COMPANY_NAME = ENV['NAME']&.underscore&.humanize.freeze
PASSWORD = (ENV['NAME'] == 'demo' ? Schematics::Attributes::Digest::DEFAULT : nil).freeze
mod = ENV['NAME'].classify.constantize

PaperTrail.request(enabled: false) do # rubocop:disable Metrics/BlockLength
  mod::Role.create!(
    [
      {
        name_en: 'Admin',
        name_fr: 'Administrateur',
        name_it: 'Amministratore',
        permissions: mod::Permission.create_entities_permissions!
      },
      {
        name_en: 'Collaborator',
        name_fr: 'Collaborateur',
        name_it: 'Collaboratore',
        permissions: mod::Permission.features
      }
    ]
  )
  mod::Configuration.instance.update!(
    company_name: COMPANY_NAME,
    available_locales: [mod::Subscription.default_locale],
    locale: mod::Subscription.default_locale
  )
  mod::Documentation.create!
  mod::Migration.default.save!
  mod::User.create!(email: 'demo@back-office.pro', password: PASSWORD, role: mod::Role.admin)
  mod::Dashboard.create!(
    [
      {
        title_en: 'Admin dashboard',
        title_fr: 'Tableau de bord administrateur',
        title_it: 'Cruscotto amministratore',
        roles: [mod::Role.admin]
      },
      {
        title_en: 'Global dashboard',
        title_fr: 'Tableau de bord global',
        title_it: 'Cruscotto globale'
      }
    ]
  )
  mod::Ranking.create!(
    model: 'ActiveStorage::Blob',
    field: 'ActiveStorage::Blob#byte_size',
    dashboards: [mod::Dashboard.first]
  )
  mod::Metric.create!(
    [
      {
        aggregate: 'count',
        model: 'Emailing',
        dashboards: mod::Dashboard.all
      },
      {
        aggregate: 'count',
        model: 'User',
        comparator: 'greater_than_or_equal_to',
        threshold: mod::Subscription.quota_users,
        dashboards: [mod::Dashboard.first]
      },
      {
        aggregate: 'count',
        model: 'APIKey',
        comparator: 'greater_than_or_equal_to',
        threshold: mod::Subscription.quota_api_keys,
        dashboards: [mod::Dashboard.first]
      },
      {
        aggregate: 'sum',
        model: 'ActiveStorage::Blob',
        field: 'ActiveStorage::Blob#byte_size',
        comparator: 'greater_than_or_equal_to',
        threshold: mod::Subscription.quota_storage,
        dashboards: [mod::Dashboard.first]
      }
    ]
  )
  mod::Chart.create_without_validations(
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
        dashboards: mod::Dashboard.all
      },
      {
        kind: 'column',
        aggregate: 'count',
        model: 'Task',
        x_field: 'Task#created_at/month',
        dashboards: mod::Dashboard.all
      }
    ]
  )
  mod::DataCleaning.create_without_validations(
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
