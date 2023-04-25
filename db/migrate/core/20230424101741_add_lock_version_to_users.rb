# frozen_string_literal: true

class AddLockVersionToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :lock_version, :integer
    add_index :users, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
