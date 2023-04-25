# frozen_string_literal: true

class CreateLicences < ActiveRecord::Migration[7.0]
  def change
    create_table :licences, id: :uuid do |t|
      t.integer :plan
      t.integer :state
      t.jsonb :metadata

      t.timestamps
    end
    add_index :licences,
              :plan,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :licences,
              :state,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :licences,
              :metadata,
              algorithm: :concurrently,
              using: :gin,
              where: 'deleted_at IS NULL'
  end
end
