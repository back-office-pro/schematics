# frozen_string_literal: true

class AddSlugToPermissions < ActiveRecord::Migration[7.0]
  def change
    add_column :permissions, :slug, :string
    add_index :permissions,
              :slug,
              unique: true,
              algorithm: :concurrently,
              where: 'deleted_at IS NULL'
  end
end
