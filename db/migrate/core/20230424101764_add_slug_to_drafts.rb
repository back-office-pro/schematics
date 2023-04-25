# frozen_string_literal: true

class AddSlugToDrafts < ActiveRecord::Migration[7.0]
  def change
    add_column :drafts, :slug, :string
    add_index :drafts, :slug, unique: true, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
