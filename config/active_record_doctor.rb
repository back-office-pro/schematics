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
    mobility_string_translations
    mobility_text_translations
    paper_trail_versions
    solid_queue_jobs
    solid_queue_semaphores
    solid_queue_recurring_tasks
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
    Mobility::Backends::ActionText::PlainTextTranslation
    Mobility::Backends::ActionText::RichTextTranslation
    SolidCache::Entry
    SolidQueue::Semaphore
    SolidQueue::Process
    SolidQueue::Pause
    SolidQueue::Job
    SolidQueue::RecurringExecution
    SolidQueue::ScheduledExecution
    SolidQueue::BlockedExecution
    SolidQueue::ReadyExecution
    SolidQueue::RecurringTask
  ]

  detector :missing_foreign_keys, enabled: false
  detector :missing_non_null_constraint, enabled: false
  detector :incorrect_length_validation, enabled: false
  detector :table_without_primary_key, enabled: false
  detector :incorrect_dependent_option, enabled: false
end
