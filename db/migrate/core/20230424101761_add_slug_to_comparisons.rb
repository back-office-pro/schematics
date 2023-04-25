# frozen_string_literal: true

class AddSlugToComparisons < ActiveRecord::Migration[7.0]
  def change
    add_column :comparisons, :slug, :string
    add_index :comparisons,
              :slug,
              unique: true,
              algorithm: :concurrently,
              where: 'deleted_at IS NULL'
  end
end
