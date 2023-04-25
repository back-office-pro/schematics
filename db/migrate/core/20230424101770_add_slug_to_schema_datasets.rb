# frozen_string_literal: true

class AddSlugToSchemaDatasets < ActiveRecord::Migration[7.0]
  def change
    add_column :schema_datasets, :slug, :string
    add_index :schema_datasets,
              :slug,
              unique: true,
              algorithm: :concurrently,
              where: 'deleted_at IS NULL'
  end
end
