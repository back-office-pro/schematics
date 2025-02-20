# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

ActiveRecordDoctor.configure do
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
    SolidCable::Message
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
    SolidQueue::ClaimedExecution
    SolidQueue::FailedExecution
  ]

  detector :missing_foreign_keys, enabled: false
  detector :missing_non_null_constraint, enabled: false
  detector :incorrect_length_validation, enabled: false
  detector :table_without_primary_key, enabled: false
  detector :incorrect_dependent_option, enabled: false
end
