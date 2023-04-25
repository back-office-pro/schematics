# frozen_string_literal: true

class AddSlugToRoles < ActiveRecord::Migration[7.0]
  def change
    add_column :roles, :slug, :string
    add_index :roles, :slug, unique: true, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
