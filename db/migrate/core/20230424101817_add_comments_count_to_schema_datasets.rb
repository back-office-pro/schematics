# frozen_string_literal: true

class AddCommentsCountToSchemaDatasets < ActiveRecord::Migration[7.0]
  def change
    add_column :schema_datasets, :comments_count, :integer
    add_index :schema_datasets,
              :comments_count,
              algorithm: :concurrently,
              where: 'deleted_at IS NULL'
  end
end
