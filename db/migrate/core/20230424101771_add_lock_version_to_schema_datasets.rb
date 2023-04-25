# frozen_string_literal: true

class AddLockVersionToSchemaDatasets < ActiveRecord::Migration[7.0]
  def change
    add_column :schema_datasets, :lock_version, :integer
    add_index :schema_datasets, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
