# frozen_string_literal: true

class AddLockVersionToApiKeys < ActiveRecord::Migration[7.0]
  def change
    add_column :api_keys, :lock_version, :integer
    add_index :api_keys, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
