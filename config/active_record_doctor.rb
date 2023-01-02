# frozen_string_literal: true

ActiveRecordDoctor.configure do
  global :ignore_tables, %w[
    ar_internal_metadata
    schema_migrations
    active_storage_blobs
    active_storage_attachments
    active_storage_variant_records
    action_text_rich_texts
    versions
    friendly_id_slugs
    good_jobs
    good_job_processes
    good_job_settings
  ]

  global :ignore_models, [
    'ActionMailbox::Record',
    'ActionMailbox::InboundEmail',
    'ActiveStorage::Record',
    'ActiveStorage::Blob',
    'ActiveStorage::Attachment',
    'ActiveStorage::VariantRecord',
    'ActionText::EncryptedRichText',
    'ActionText::RichText',
    'ActionText::Record',
    'PaperTrail::Version',
    'Schematics::ApplicationRecord',
    'Schematics::Version',
    'FriendlyId::Slug',
    'ApplicationRecord',
    'GoodJob::BaseRecord',
    'GoodJob::Job'
  ]

  detector :missing_foreign_keys, enabled: false
  detector :missing_non_null_constraint, enabled: false
  detector :incorrect_length_validation, enabled: false
  detector :incorrect_dependent_option, enabled: false
end
