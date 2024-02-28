# frozen_string_literal: true

ActiveRecordDoctor.configure do
  global :ignore_tables, %w[
    ar_internal_metadata
    schema_migrations
    active_storage_blobs
    active_storage_attachments
    active_storage_variant_records
    action_text_rich_texts
    friendly_id_slugs
    good_jobs
    good_job_batches
    good_job_processes
    good_job_settings
    good_job_executions
    mobility_string_translations
    mobility_text_translations
    paper_trail_versions
  ]

  global :ignore_models, %w[
    ActionMailbox::Record
    ActionMailbox::InboundEmail
    ActiveStorage::Record
    ActiveStorage::Blob
    ActiveStorage::Attachment
    ActiveStorage::VariantRecord
    ActionText::EncryptedRichText
    ActionText::RichText
    ActionText::Record
    PaperTrail::Version
    Schematics::ApplicationRecord
    Schematics::Version
    FriendlyId::Slug
    ApplicationRecord
    GoodJob::BaseRecord
    GoodJob::BatchRecord
    GoodJob::Execution
    GoodJob::ActiveJobJob
    GoodJob::Job
    GoodJob::DiscreteExecution
    Mobility::Backends::ActionText::PlainTextTranslation
    Mobility::Backends::ActionText::RichTextTranslation
    SolidCache::Entry
  ]

  detector :missing_foreign_keys, enabled: false
  detector :missing_non_null_constraint, enabled: false
  detector :incorrect_length_validation, enabled: false
end
