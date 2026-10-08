# frozen_string_literal: true

class CreateActiveStorageTables < ActiveRecord::Migration[8.1]
  def change
    create_table :active_storage_blobs, id: :string do |t|
      t.string   :key,          null: false
      t.string   :filename,     null: false
      t.string   :content_type
      t.text     :metadata
      t.string   :service_name, null: false
      t.bigint   :byte_size,    null: false
      t.string   :checksum
      t.datetime :deleted_at, index: { where: 'deleted_at IS NULL' }

      t.timestamps index: { where: 'deleted_at IS NULL' }

      t.index :key, using: :btree, unique: true, where: 'deleted_at IS NULL'
      t.index :filename, using: :btree, where: 'deleted_at IS NULL'
      t.index :content_type, using: :btree, where: 'deleted_at IS NULL'
      t.index :byte_size, using: :btree, where: 'deleted_at IS NULL'
    end

    create_table :active_storage_attachments, id: :string do |t|
      t.string     :name,   null: false
      t.references :record, null: false, polymorphic: true, index: false, type: :string
      t.references :blob,   null: false, type: :string, index: { where: 'deleted_at IS NULL' }
      t.datetime   :deleted_at, index: { where: 'deleted_at IS NULL' }

      t.timestamps index: { where: 'deleted_at IS NULL' }

      t.index %i[record_type record_id name blob_id],
              name: :index_active_storage_attachments_uniqueness,
              unique: true,
              where: 'deleted_at IS NULL'
      t.foreign_key :active_storage_blobs, column: :blob_id
    end

    create_table :active_storage_variant_records, id: :string do |t|
      t.belongs_to :blob, null: false, index: false, type: :string
      t.string     :variation_digest, null: false
      t.datetime   :deleted_at, index: { where: 'deleted_at IS NULL' }

      t.timestamps index: { where: 'deleted_at IS NULL' }

      t.index %i[blob_id variation_digest],
              name: :index_active_storage_variant_records_uniqueness,
              unique: true,
              where: 'deleted_at IS NULL'
      t.foreign_key :active_storage_blobs, column: :blob_id
    end
  end
end
