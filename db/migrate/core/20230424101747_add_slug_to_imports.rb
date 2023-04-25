# frozen_string_literal: true

class AddSlugToImports < ActiveRecord::Migration[7.0]
  def change
    add_column :imports, :slug, :string
    add_index :imports, :slug, unique: true, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
