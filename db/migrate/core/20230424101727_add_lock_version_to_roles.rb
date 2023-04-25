# frozen_string_literal: true

class AddLockVersionToRoles < ActiveRecord::Migration[7.0]
  def change
    add_column :roles, :lock_version, :integer
    add_index :roles, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
