# frozen_string_literal: true

class CreateCharts < ActiveRecord::Migration[7.0]
  def change
    create_table :charts, id: :uuid do |t|
      t.integer :kind
      t.integer :agregate
      t.string :model
      t.string :y_field
      t.string :x_field

      t.timestamps
    end
    add_index :charts,
              :kind,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :charts,
              :agregate,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :charts,
              :model,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :charts,
              :y_field,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :charts,
              :x_field,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
  end
end
