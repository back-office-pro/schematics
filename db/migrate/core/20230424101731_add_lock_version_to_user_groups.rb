# frozen_string_literal: true

class AddLockVersionToUserGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :user_groups, :lock_version, :integer
    add_index :user_groups, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
