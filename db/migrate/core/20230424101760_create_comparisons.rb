# frozen_string_literal: true

class CreateComparisons < ActiveRecord::Migration[7.0]
  def change
    create_table :comparisons, id: :uuid do |t|
      t.string :model
      t.string :ids, array: true

      t.timestamps
    end
    add_index :comparisons,
              :model,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :comparisons,
              :ids,
              algorithm: :concurrently,
              using: :gin,
              where: 'deleted_at IS NULL'
  end
end
