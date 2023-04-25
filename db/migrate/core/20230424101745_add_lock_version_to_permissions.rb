# frozen_string_literal: true

class AddLockVersionToPermissions < ActiveRecord::Migration[7.0]
  def change
    add_column :permissions, :lock_version, :integer
    add_index :permissions, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
