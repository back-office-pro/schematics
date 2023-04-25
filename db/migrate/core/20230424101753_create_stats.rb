# frozen_string_literal: true

class CreateStats < ActiveRecord::Migration[7.0]
  def change
    create_table :stats, id: :uuid do |t|
      t.integer :agregate
      t.string :model
      t.string :field

      t.timestamps
    end
    add_index :stats,
              :agregate,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :stats,
              :model,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :stats,
              :field,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
  end
end
