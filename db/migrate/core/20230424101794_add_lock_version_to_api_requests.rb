# frozen_string_literal: true

class AddLockVersionToApiRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :api_requests, :lock_version, :integer
    add_index :api_requests, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
