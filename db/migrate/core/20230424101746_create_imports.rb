# frozen_string_literal: true

class CreateImports < ActiveRecord::Migration[7.0]
  def change
    create_table :imports, id: :uuid do |t|
      t.string :model
      t.integer :status
      t.float :progress
      t.jsonb :import_errors
      t.references :author, index: { where: 'deleted_at IS NULL' }, type: :uuid

      t.timestamps
    end
    add_index :imports,
              :model,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :imports,
              :status,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :imports,
              :progress,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :imports,
              :import_errors,
              algorithm: :concurrently,
              using: :gin,
              where: 'deleted_at IS NULL'
  end
end
