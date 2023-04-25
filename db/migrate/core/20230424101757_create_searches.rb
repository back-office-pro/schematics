# frozen_string_literal: true

class CreateSearches < ActiveRecord::Migration[7.0]
  def change
    create_table :searches, id: :uuid do |t|
      t.string :query
      t.string :model
      t.jsonb :filters
      t.references :user, index: { where: 'deleted_at IS NULL' }, type: :uuid

      t.timestamps
    end
    add_index :searches,
              :query,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :searches,
              :model,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :searches,
              :filters,
              algorithm: :concurrently,
              using: :gin,
              where: 'deleted_at IS NULL'
  end
end
