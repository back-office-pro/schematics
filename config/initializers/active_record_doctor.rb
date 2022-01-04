# frozen_string_literal: true

require 'active_record_doctor'

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
  ]

  global :ignore_models, [
    'ActionMailbox::InboundEmail',
    'ActiveStorage::Blob',
    'ActiveStorage::Attachment',
    'ActiveStorage::VariantRecord',
    'ActionText::RichText',
    'PaperTrail::Version',
    'Schematics::Version',
    'FriendlyId::Slug'
  ]

  detector :extraneous_indexes, ignore_tables: [], ignore_indexes: []
  detector :incorrect_boolean_presence_validation, ignore_models: [], ignore_attributes: []
  detector :mismatched_foreign_key_type, ignore_tables: [], ignore_columns: []
  detector :missing_foreign_keys, ignore_tables: ['permissions_roles'], ignore_columns: []
  detector :missing_non_null_constraint, ignore_tables: [], ignore_columns: []
  detector :missing_presence_validation, ignore_models: [], ignore_attributes: []
  detector :missing_unique_indexes, ignore_models: [], ignore_columns: []
  detector :short_primary_key_type,
           ignore_tables: Schematics::Schema
             .instance
             .entities
             .map(&:table_name)
             .map(&:pluralize)
             .push('searches')
  detector :undefined_table_references, ignore_models: []
  detector :unindexed_foreign_keys, ignore_tables: [], ignore_columns: []
  detector :incorrect_dependent_option,
           ignore_models: [],
           ignore_associations: Schematics::Schema
             .instance
             .entities
             .map(&:class_name)
             .map { "#{_1}.slugs" }
  detector :unindexed_deleted_at,
           ignore_tables: [],
           ignore_columns: [],
           ignore_indexes: [],
           column_names: []
end
