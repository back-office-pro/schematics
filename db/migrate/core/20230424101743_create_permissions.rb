# frozen_string_literal: true

class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions, id: :uuid do |t|
      t.string :model
      t.string :action

      t.timestamps
    end
    add_index :permissions,
              :model,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :permissions,
              :action,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
  end
end
