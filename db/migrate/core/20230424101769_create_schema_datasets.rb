# frozen_string_literal: true

class CreateSchemaDatasets < ActiveRecord::Migration[7.0]
  def change
    create_table :schema_datasets, id: :uuid do |t|
      t.jsonb :data
      t.integer :state

      t.timestamps
    end
    add_index :schema_datasets,
              :data,
              algorithm: :concurrently,
              using: :gin,
              where: 'deleted_at IS NULL'
    add_index :schema_datasets,
              :state,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
  end
end
